// routes/image.js — GROK with Shot Planner
const fetch = (...a) => import("node-fetch").then(({ default: f }) => f(...a));
const { getBook } = require("../store");
const { mapStyleLabel, mapGenreLabel, extractKeywords } = require("../helpers");
const { buildShotPlan, shotToPrompt } = require("../utils/shot-planner");

function hashCode(str){ let h=0; for(let i=0;i<str.length;i++){ h=((h<<5)-h)+str.charCodeAt(i); h|=0; } return h>>>0; }

function characterLockLines(c){
  const out = [];
  const name = c.display_name || c.id;
  out.push(`Character "${name}" (id:${c.id}) — keep identity and proportions consistent.`);
  if (c.costume?.primary) out.push(`Outfit: ${c.costume.primary} (do not change).`);
  if (c.material_lock) out.push(`Material lock: ${c.material_lock} (do not change).`);
  if (c.color_lock?.base) out.push(`Color lock: base ${c.color_lock.base}${c.color_lock.accents?.length ? `, accents ${c.color_lock.accents.join("/")}` : ""} (do not change).`);
  return out;
}

function mountImageRoute(app, RULES) {
  app.post("/api/image", async (req, res) => {
    try {
      const { book_id, page=1, lines=[], styleLabel, genreLabel, visual_focus } = req.body || {};
      const book = getBook(book_id);
      if (!book) return res.status(400).json({ error: "unknown book_id" });
      book.rules = RULES;

      const { art_bible } = book;
      const styleKey = mapStyleLabel(styleLabel);
      const genreKey = mapGenreLabel(genreLabel);
      const style = RULES.styles.find(s => s.key === styleKey) || RULES.styles[0];
      const genre = RULES.genres.find(g => g.key === genreKey) || RULES.genres[0];

      // --- Shot planning (varied subject + framing) ---
      const shot = buildShotPlan({ lines, visual_focus, page });
      const lead = (art_bible.characters||[]).find(c => c.id==="lead")?.display_name;
      const supports = (art_bible.characters||[]).filter(c => c.id!=="lead").map(c=>c.display_name);
      const shotLines = shotToPrompt(shot, lead, supports);

      // --- Character locks & negatives ---
      const rosterLocks = (art_bible.characters||[]).flatMap(characterLockLines).join(" ");
      const charNegs = [];
      for (const c of art_bible.characters || []) {
        if (c.color_lock?.forbid?.length) {
          for (const f of c.color_lock.forbid) charNegs.push(`no ${f} on ${c.display_name||c.id}`);
          charNegs.push(`no color shift on ${c.display_name||c.id}`);
        }
        if (shot.exclude?.length && shot.exclude.includes("lead?") && c.id==="lead" && lead){
          charNegs.push(`no portrait of ${lead}`);
        }
        if (c.material_lock) {
          charNegs.push(`do not change ${c.display_name||c.id} material from ${c.material_lock}`);
        }
      }

      // --- Build prompt text (max 1024 chars for Grok) ---
      const keywords = extractKeywords(lines);
      const shortRosterLocks = (art_bible.characters||[]).map(c => 
        `${c.display_name||c.id}: ${c.costume?.primary||'consistent'}`
      ).join(", ");
      
      const prompt = [
        `${style.base}`,
        `${shotLines.planLine}`,
        `SCENE: ${lines.join(" ").trim()}`,
        `CHARS: ${shortRosterLocks}`,
        `PALETTE: ${art_bible.book_meta.palette.slice(0,3).join(", ")}`
      ].join(" | ");

      const negative_prompt = [
        ...(style.negatives||[]),
        ...(art_bible.negatives_global||[]),
        ...charNegs,
        ...shotLines.negatives,
        "no brand logos; no watermark; no extreme film grain",
        "no outfit changes; no hair color/length changes; keep proportions consistent"
      ].join("; ");

      console.log('🎨 Calling Grok API with:', JSON.stringify({
        model: process.env.GROK_IMAGE_MODEL || "grok-2-image-1212",
        prompt,
        n: 1,
        response_format: 'b64_json'
      }, null, 2));

      // --- Call Grok Imagine ---
      const seed = Math.floor(Math.abs(hashCode(`book:${art_bible.book_meta.book_id}:p${page}:${shot.focus}`)) % 2147483647);
      const r = await fetch(process.env.GROK_IMAGE_URL || 'https://api.x.ai/v1/images/generations', {
        method: "POST",
        headers: {
          "authorization": `Bearer ${process.env.GROK_API_KEY}`,
          "content-type": "application/json"
        },
        body: JSON.stringify({
          model: process.env.GROK_IMAGE_MODEL || "grok-2-image-1212",
          prompt,
          n: 1,
          response_format: 'b64_json'
        })
      });

      console.log('🎨 Grok API response status:', r.status);
      const j = await r.json();
      console.log('🎨 Grok API response body:', JSON.stringify(j, null, 2));
      const b64 = j?.data?.[0]?.b64_json || j?.image_b64 || null;

      res.json({ 
        page, 
        provider:"grok", 
        style: book.art_bible.book_meta.style_key,
        image_b64:b64, 
        visual_focus_used: shot.focus,
        job_used: { model: process.env.GROK_IMAGE_MODEL, prompt, negative_prompt, seed }
      });
    } catch (e) {
      console.error(e);
      res.status(500).json({ error:"image route error", detail:String(e) });
    }
  });
}

module.exports = { mountImageRoute };
