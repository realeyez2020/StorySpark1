// routes/story-claude.js
const Anthropic = require("@anthropic-ai/sdk");
const { z } = require("zod");
const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });
const { getBook, getStorySoFar, getOutline, pushPage } = require("../store");

const AuthorOutput = z.object({
  page: z.number().int().min(1),
  lines: z.array(z.string()).min(2).max(4),
  scene_hint: z.string().optional(),
  mentions: z.array(z.string()).optional(),
  visual_focus: z.enum([
    "lead_close","lead_medium","supporting_close","group_wide","environment_estab","object_macro"
  ]).optional(),
  passes_checks: z.boolean()
});

const BAD_OPENERS = ["once upon a time","in a magical world","long ago","in a land far away"];

function shouldRhyme(genreKey, force, defaults){ const def=!!(defaults||{bedtime:true})[genreKey]; return typeof force==="boolean"?force:def; }

function buildPrompt({allowedNames, ageBand, rhyme, page, idea, story_bible, storySoFar, beat}){
  const system = [
    "You are a children's picture-book author (ages 4–12).",
    "Third-person past tense; warm, reassuring tone; no brands.",
    `Do NOT use these openers: ${BAD_OPENERS.join("; ")}.`,
    "Honor the Story Bible for names/outfits/age-safety.",
    "Rhyme only if RHYME:true; if rhyming, AABB ~8 syllables/line."
  ].join(" ");

  const user = `
ALLOWED NAMES: ${allowedNames.join(", ")}
AGE BAND: ${ageBand}
RHYME: ${rhyme}
PAGE: ${page}
CURRENT IDEA: ${idea}

BEAT GUIDANCE (page ${beat?.page || page}): ${beat ? JSON.stringify(beat) : "n/a"}

STORY SO FAR (previous pages): ${JSON.stringify(storySoFar)}

STORY BIBLE: ${JSON.stringify(story_bible)}

OUTPUT STRICT JSON ONLY:
{
  "page": ${page},
  "lines": ["<2-4 short lines continuing the same story>"],
  "scene_hint": "<short scene summary>",
  "mentions": ["<names used>"],
  "visual_focus": "<one of: lead_close | lead_medium | supporting_close | group_wide | environment_estab | object_macro>",
  "passes_checks": true
}
Rules:
- Continue the SAME story—keep names, outfits, facts, timeline.
- Use ONLY allowed names in lines.
- Keep sentences short (≤12 words avg; ≤16 max). Kid-safe.
- Choose visual_focus to match the best picture for this page (not always the lead).
- If an attribute is locked (e.g., robot material/color), use exactly the locked wording when mentioned.
- Return ONLY JSON.
`;
  return { system, user };
}

async function askClaude(system, user){
  const resp = await anthropic.messages.create({
    model: process.env.ANTHROPIC_MODEL || "claude-3-5-sonnet-latest",
    max_tokens: 800, temperature: 0.5, system,
    messages: [{ role: "user", content: [{ type: "text", text: user }] }]
  });
  const raw = resp.content?.[0]?.type === "text" ? resp.content[0].text : "{}";
  
  // Clean up Claude's response to extract JSON
  let cleaned = raw.replace(/```json\s*/, '').replace(/```\s*$/, '');
  cleaned = cleaned.replace(/^Here's.*?:\s*/s, '');
  cleaned = cleaned.replace(/^.*?({.*}).*$/s, '$1');
  cleaned = cleaned.trim();
  
  let data; 
  try { 
    data = JSON.parse(cleaned); 
  } catch { 
    data = {}; 
  }
  return data;
}

function hasForbiddenColors(lines, story_bible){
  const locked = (story_bible.characters||[]).filter(c => c.color_lock || c.material_lock);
  for(const c of locked){
    const forb = (c.color_lock?.forbid||[]).map(x => `\\b${x}\\b`).join("|");
    if(!forb) continue;
    const rx = new RegExp(forb, "i");
    for(const ln of lines){ if(rx.test(ln)) return { character: c.id, line: ln }; }
  }
  return null;
}

function badOpener(first){
  const s = String(first||"").toLowerCase().trim();
  return BAD_OPENERS.some(x => s.startsWith(x));
}

function mountStoryRoute(app){
  app.post("/api/story", async (req,res)=>{
    try{
      const { book_id, page=1, idea="", forceRhyme } = req.body || {};
      const book = getBook(book_id);
      if(!book) return res.status(400).json({ error:"unknown book_id" });

      const { story_bible, art_bible } = book;
      const allowed = story_bible.writer_policy.naming_rules.allowed_names;
      const rhyme = shouldRhyme(art_bible.book_meta.genre_key, forceRhyme, story_bible.writer_policy.rhyme_default_by_genre);
      const storySoFar = getStorySoFar(book_id);
      const beat = (getOutline(book_id) || [])[page-1];

      // First attempt
      let { system, user } = buildPrompt({
        allowedNames: allowed, ageBand: art_bible.book_meta.age_band, rhyme,
        page, idea, story_bible, storySoFar, beat
      });
      let out = await askClaude(system, user);
      let parsed = AuthorOutput.safeParse(out);
      let reason = "";

      // Validate + simple repair/one retry
      const invalidNames = (out.mentions||[]).filter(n => !allowed.includes(n));
      const colorHit = !parsed.success ? null : hasForbiddenColors(out.lines||[], story_bible);
      const openerBad = parsed.success && badOpener(out.lines?.[0]);

      if(!parsed.success || invalidNames.length || colorHit || openerBad){
        reason = JSON.stringify({
          schema_ok: parsed.success,
          invalid_names: invalidNames,
          color_hit: colorHit,
          opener_bad: openerBad
        });
        const critique = `
You violated one or more constraints: ${reason}
Please FIX and re-output STRICT JSON for PAGE ${page}.
- Use only allowed names: ${allowed.join(", ")}
- Do not mention forbidden colors/materials for locked characters.
- Do not use banned openers. Maintain continuity with STORY SO FAR.
Return JSON only.`;
        out = await askClaude(system, user + "\n\nCRITIQUE:\n" + critique);
        parsed = AuthorOutput.safeParse(out);
        if(!parsed.success){
          return res.status(422).json({ error:"Schema validation failed after retry", detail: reason, raw: out });
        }
      }

      // Save to history
      pushPage(book_id, page, out.lines, out.scene_hint);

      res.json(out);
    }catch(e){
      console.error(e);
      res.status(500).json({ error:"Claude route error", detail:String(e) });
    }
  });
}
module.exports = { mountStoryRoute };
