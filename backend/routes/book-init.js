// routes/book-init.js
const { randomUUID } = require("crypto");
const { mapStyleLabel, mapGenreLabel } = require("../helpers");
const { putBook } = require("../store");

const NAME_POOL = ["Noah","Maya","Jade","Omar","Ava","Leo","Rina","Mateo","Zoe","Iris","Arun","Luca","Nia","Kai","Elio","Sora"];
function pickNames(n, seed) {
  // Use a better hash of the seed instead of just length
  let hash = 0;
  if (!seed) seed = Date.now().toString();
  for (let i = 0; i < seed.length; i++) {
    hash = ((hash << 5) - hash) + seed.charCodeAt(i);
    hash = hash & hash; // Convert to 32bit integer
  }
  const s = Math.abs(hash) % NAME_POOL.length;
  const out = [];
  for (let i = 0; i < n; i++) out.push(NAME_POOL[(s + i) % NAME_POOL.length]);
  return out;
}

function mountBookInitRoute(app, RULES) {
  app.post("/api/book/init", async (req, res) => {
    try {
      const {
        pitch = "",
        styleLabel = "Classic Storybook 📚",
        genreLabel = "Fantasy 🧙",
        ageBand = "kids",
        allowAiNames = true,      // keep for UI parity
        forceRhyme = false,
        bookSize = "picture-book"  // NEW: book format
      } = req.body || {};

      const book_id = randomUUID();
      const style_key = mapStyleLabel(styleLabel);
      const genre_key = mapGenreLabel(genreLabel);

      // Book size configurations
      const bookFormats = {
        "picture-book": { 
          width: 1600, height: 1200, // 4:3 landscape - classic picture book
          name: "Picture Book (8.5×11)",
          pages: 5
        },
        "square-book": { 
          width: 1200, height: 1200, // 1:1 square - modern children's book
          name: "Square Book (8×8)",
          pages: 5
        },
        "board-book": { 
          width: 1000, height: 1000, // 1:1 square but smaller - sturdy for toddlers
          name: "Board Book (6×6)", 
          pages: 3
        },
        "chapter-book": { 
          width: 900, height: 1200, // 3:4 portrait - illustrated chapter book
          name: "Chapter Book (6×8)",
          pages: 8
        }
      };

      const format = bookFormats[bookSize] || bookFormats["picture-book"];

      // Simple roster creation (deterministic). You can replace with Claude if you want.
      const [leadName] = pickNames(1, book_id);
      console.log(`🎯 Name selection for ${book_id.slice(0,8)}...: ${leadName}`);
      const roster = [];
      roster.push({
        id: "lead",
        display_name: allowAiNames ? leadName : "the child",
        kind: "human",
        summary: "curious child",
        outfit: "blue hoodie, jeans, sneakers"
      });

      // If pitch mentions a robot, add a locked robot character
      if (/\brobot\b/i.test(pitch)) {
        roster.push({
          id: "robot1",
          display_name: allowAiNames ? "Robo" : "the robot",
          kind: "robot",
          summary: "gentle helper",
          outfit_or_look: "rounded shape, soft blue lights",
          material_lock: "brushed aluminum silver",
          color_lock: {
            base: "#C0C0C0",
            accents: ["#6EC1FF"],
            forbid: ["copper","bronze","gold","black","rust","green patina"]
          }
        });
      }

      const story_bible = {
        book_id,
        writer_policy: {
          tense: "past",
          pov: "third",
          rhyme_default_by_genre: { bedtime: true },
          ban_cliche_openers: RULES.ban_cliche_openers,
          naming_rules: {
            allow_new_names: false,
            allowed_names: roster.map(c => c.display_name),
            rename_robot_when_ready: false
          }
        },
        characters: roster.map(c => ({
          id: c.id,
          display_name: c.display_name,
          kind: c.kind,
          summary: c.summary || "",
          outfit: c.outfit || c.outfit_or_look || "",
          material_lock: c.material_lock,
          color_lock: c.color_lock
        })),
        setting_hint: pitch
      };

      const art_bible = {
        book_meta: {
          book_id,
          style_key,
          genre_key,
          age_band: ageBand,
          book_format: bookSize,
          format_name: format.name,
          render_size: `${format.width}x${format.height}`,
          max_pages: format.pages,
          palette: ["lemon","lavender","teal","sage","apricot"],
          camera: { height: "child-eye", fov: 35 },
          lighting: "warm summer key, soft rim",
          locks: [
            "style_key","palette","camera","lighting",
            "characters.core_identity","characters.costume","characters.color_material"
          ]
        },
        world: { locale: "from pitch", era: "unspecified" },
        characters: story_bible.characters.map(c => ({
          id: c.id,
          display_name: c.display_name,
          costume: { primary: c.outfit || "—", allow_outfit_change: false },
          core_identity: { notes: c.summary },
          material_lock: c.material_lock,
          color_lock: c.color_lock,
          refs: []
        })),
        negatives_global: [
          "no brand/trademarked characters or logos",
          "no weapons/gore/scary imagery",
          "no color/material changes to locked characters",
          "no photoreal harsh shadows; keep soft, kid-safe"
        ],
        forceRhyme: !!forceRhyme
      };

      // Generate outline based on book format
      const outlineTemplates = {
        3: [ // Board book - simple 3-beat story
          { page:1, title:"Problem",      setting:"where it starts", goal:"meet character", turn:"something wrong" },
          { page:2, title:"Try",          setting:"action taken", goal:"solve problem", turn:"almost works" },
          { page:3, title:"Success",      setting:"happy ending", goal:"lesson learned", turn:"all better" }
        ],
        5: [ // Picture book - classic 5-act structure
          { page:1, title:"Setup",        setting:"where it starts", goal:"meet cast", turn:"inciting oddity" },
          { page:2, title:"Escalation",   setting:"first location change", goal:"investigate", turn:"small setback" },
          { page:3, title:"Complication", setting:"crowds/pressure", goal:"try again", turn:"bigger problem" },
          { page:4, title:"Turning Point",setting:"close to answer", goal:"choose kindness", turn:"plan forms" },
          { page:5, title:"Resolution",   setting:"calm after", goal:"lesson learned", turn:"community together" }
        ],
        8: [ // Chapter book - extended story arc
          { page:1, title:"Introduction", setting:"ordinary world", goal:"meet hero", turn:"call to adventure" },
          { page:2, title:"Departure",    setting:"leaving home", goal:"start journey", turn:"first challenge" },
          { page:3, title:"Challenge",    setting:"new place", goal:"overcome obstacle", turn:"meets ally" },
          { page:4, title:"Growth",       setting:"deeper journey", goal:"learn skill", turn:"bigger test" },
          { page:5, title:"Crisis",       setting:"darkest moment", goal:"face fear", turn:"seems lost" },
          { page:6, title:"Breakthrough", setting:"inner strength", goal:"find courage", turn:"new plan" },
          { page:7, title:"Climax",       setting:"final battle", goal:"save day", turn:"victory" },
          { page:8, title:"Return",       setting:"back home", goal:"share wisdom", turn:"transformed" }
        ]
      };

      const outline = outlineTemplates[format.pages] || outlineTemplates[5];

      // Attach to book
      const bookPayload = { story_bible, art_bible, rules: RULES, outline, pages: [] };
      putBook(book_id, bookPayload);
      console.log(`📚 Book initialized: ${book_id} with character: ${leadName}`);
      res.json({ book_id, story_bible, art_bible, outline });
    } catch (e) {
      console.error(e);
      res.status(500).json({ error: "book init error", detail: String(e) });
    }
  });
}
module.exports = { mountBookInitRoute };
