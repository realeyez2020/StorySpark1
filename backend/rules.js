const RULES = {
  "styles": [
    {
      "label": "Classic Storybook 📚",
      "key": "watercolor_storybook",
      "base": "soft watercolor wash; rounded shapes; gentle paper texture; clean outlines; cozy natural light",
      "technique": ["wet-on-wet blends","granulation speckles","ink outline (thin)"],
      "quality": ["high-detail brush texture","no muddy colors"],
      "negatives": ["hard speculars","photoreal shadows","logo watermarks"]
    },
    {
      "label": "Comic Book 💥",
      "key": "comic_color",
      "base": "color comic page; bold inked lines; ben-day halftone dots; CMYK pop; panel-safe gutters",
      "technique": ["dynamic poses","screen tones","speed lines (subtle)"],
      "quality": ["pin-sharp inks","clean flats"],
      "negatives": ["gore","real brand logos","photo textures"]
    },
    {
      "label": "Disney Style 🏰",
      "key": "cinematic_3d_family",
      "base": "stylized 3D family animation; rounded anatomy; warm cinematic key + soft rim; painterly textures; sun-washed palette",
      "technique": ["subsurface skin","soft DOF","micro-roughness fabrics"],
      "quality": ["film-like sharpness","no plastic glare"],
      "negatives": ["named franchises","logos","weapons"]
    },
    {
      "label": "Anime Style 🎭",
      "key": "anime_tv",
      "base": "clean cel-shaded 2D animation; soft gradient skies; readable silhouettes; subtle bloom",
      "technique": ["consistent line weight","limited palette per scene"],
      "quality": ["high-res raster","no jittered lines"],
      "negatives": ["hyper-real pores","weapon realism","brand logos"]
    },
    {
      "label": "Pixar 3D 🎨",
      "key": "cinematic_3d_family",
      "base": "stylized 3D family animation; rounded anatomy; warm cinematic key + soft rim; painterly textures; sun-washed palette",
      "technique": ["subsurface skin","soft DOF","micro-roughness fabrics"],
      "quality": ["film-like sharpness","no plastic glare"],
      "negatives": ["named franchises","logos","weapons"]
    },
    {
      "label": "Watercolor Art 🎨",
      "key": "watercolor_storybook",
      "base": "soft watercolor wash; rounded shapes; gentle paper texture; clean outlines; cozy natural light",
      "technique": ["wet-on-wet","paper grain"],
      "quality": ["high-detail brush texture"],
      "negatives": ["muddy colors","harsh contrast"]
    },
    {
      "label": "Cartoon Style 🎪",
      "key": "cartoony_cutout",
      "base": "flat paper cut-out look; bold outlines; geometric shapes; soft drop shadows",
      "technique": ["layered paper edges","overlap shadows"],
      "quality": ["clean shape edges"],
      "negatives": ["photoreal lighting","tiny noisy patterns"]
    },
    {
      "label": "Manga Style 📖",
      "key": "manga_bw",
      "base": "black-and-white manga; crisp inked lineart; clean screentones; high contrast",
      "technique": ["tone dot patterns","cross-hatching","panel-safe gutters"],
      "quality": ["pin-sharp lines","300–600dpi feel"],
      "negatives": ["color fills","gore","watermarks"]
    },
    {
      "label": "Fairy Tale 🧚‍♀️",
      "key": "storybook_ornate",
      "base": "ornate storybook illustration; delicate ink; soft watercolor fills; gold-accent vibe (no metallic textures)",
      "technique": ["decorative borders","floral motifs"],
      "quality": ["clean, printable detail"],
      "negatives": ["real royal crests","dark horror tone"]
    },
    {
      "label": "Modern Minimalist ✨",
      "key": "flat_minimal",
      "base": "flat vector shapes; large negative space; soft gradients; simple geometry",
      "technique": ["2–3 weights of line","limited palette"],
      "quality": ["crisp edges","no banding"],
      "negatives": ["busy textures","photo elements"]
    },
    {
      "label": "Pop Art 🌈",
      "key": "pop_halftone",
      "base": "bold high-contrast pop; duotone blocks; halftone dots; thick outline",
      "technique": ["offset print vibe","screen misregistration (subtle)"],
      "quality": ["sharp halftone"],
      "negatives": ["brand logos","gore"]
    },
    {
      "label": "Vintage Illustration 📰",
      "key": "vintage_print",
      "base": "mid-century children's book; limited risograph palette; off-register charm; paper grain",
      "technique": ["rough ink","stamped textures"],
      "quality": ["clean scan feel"],
      "negatives": ["modern logos","photoreal lighting"]
    }
  ],
  "genres": [
    {
      "label": "Fantasy 🧙‍♀️",
      "key": "fantasy",
      "rhyme_default": false,
      "voice": { "tense": "past", "pov": "third" },
      "tone": ["wonder","hopeful","gentle magic"],
      "ban_intros": true,
      "must_include": ["clear beginning-middle-end","positive resolution"],
      "image_scene_kit": ["mythic flora","soft glows","floating lights","simple castles (no trademarks)"],
      "age_overrides": {
        "pre_k": ["no peril","smiling creatures only"],
        "kids": ["mild suspense allowed"],
        "tweens": ["deeper lore ok"]
      }
    },
    {
      "label": "Adventure 🗺️",
      "key": "adventure",
      "rhyme_default": false,
      "voice": { "tense": "past", "pov": "third" },
      "tone": ["brisk","brave but kind","exploration"],
      "ban_intros": true,
      "must_include": ["teamwork","map/clue beats"],
      "image_scene_kit": ["maps","landmarks","trail markers","friendly outdoor scenes"],
      "age_overrides": {
        "pre_k": ["no cliffs","no chases"],
        "kids": ["gentle tension"],
        "tweens": ["bigger stakes without harm"]
      }
    },
    {
      "label": "Space 🚀",
      "key": "space",
      "rhyme_default": false,
      "voice": { "tense": "past", "pov": "third" },
      "tone": ["curious","awe","science is friendly"],
      "ban_intros": true,
      "must_include": ["robot pals","curiosity","no dystopia"],
      "image_scene_kit": ["rounded starships","pastel nebulae","friendly robots","soft space lighting"],
      "age_overrides": {
        "pre_k": ["no darkness"],
        "kids": ["dim scenes allowed with warm lights"],
        "tweens": ["darker skies ok"]
      }
    },
    {
      "label": "Friendship 🤝",
      "key": "friendship",
      "rhyme_default": false,
      "voice": { "tense": "past", "pov": "third" },
      "tone": ["warm","supportive","heartwarming"],
      "ban_intros": true,
      "must_include": ["clear emotions","simple problem/solution"],
      "image_scene_kit": ["parks","classrooms","backyards","cozy indoor spaces"],
      "age_overrides": {
        "pre_k": ["ultra simple conflicts"],
        "kids": ["apologies/resolution"],
        "tweens": ["nuanced feelings ok"]
      }
    },
    {
      "label": "Animals 🐾",
      "key": "animals",
      "rhyme_default": false,
      "voice": { "tense": "past", "pov": "third" },
      "tone": ["cozy","silly","heartwarming"],
      "ban_intros": true,
      "must_include": ["clear emotions","simple problem/solution"],
      "image_scene_kit": ["parks, dens, burrows; oversized leaves","round features, big eyes"],
      "age_overrides": {
        "pre_k": ["no predator scenes"],
        "kids": ["gentle mischief"],
        "tweens": ["light adventure ok"]
      }
    },
    {
      "label": "Mystery 🕵️",
      "key": "mystery",
      "rhyme_default": false,
      "voice": { "tense": "past", "pov": "third" },
      "tone": ["curious","reassuring","light suspense (age-based)"],
      "ban_intros": true,
      "must_include": ["clues","red herrings","friendly reveal"],
      "image_scene_kit": ["bulletin boards, yarn lines, magnifiers","warm indoor lamps","no police gear"],
      "age_overrides": {
        "pre_k": ["no night scenes"],
        "kids": ["dusk ok, warm lights"],
        "tweens": ["light fog ok"]
      }
    },
    {
      "label": "Educational 📖",
      "key": "educational",
      "rhyme_default": false,
      "voice": { "tense": "past", "pov": "third" },
      "tone": ["clear","encouraging","discovery"],
      "ban_intros": true,
      "must_include": ["learning moments","curiosity"],
      "image_scene_kit": ["diagrams","labels","infographics","classroom scenes"],
      "age_overrides": {
        "pre_k": ["picture-forward"],
        "kids": ["simple facts"],
        "tweens": ["deeper concepts ok"]
      }
    },
    {
      "label": "Bedtime 🌙",
      "key": "bedtime",
      "rhyme_default": true,
      "voice": { "tense": "past", "pov": "third" },
      "tone": ["calming","lullaby","low contrast"],
      "ban_intros": true,
      "must_include": ["slower cadence","soft endings"],
      "image_scene_kit": ["midnight blues, stars, moonbeams","vignette lighting, no high contrast"],
      "age_overrides": {
        "pre_k": ["very low contrast"],
        "kids": ["whisper-soft"],
        "tweens": ["reflective"]
      }
    }
  ],
  "ban_cliche_openers": [
    "once upon a time",
    "in a magical world", 
    "long ago",
    "in a land far away",
    "there once was",
    "once there was",
    "in the beginning",
    "a long time ago",
    "many years ago",
    "far far away",
    "in a kingdom",
    "once when"
  ],
  "character_names": {
    "fantasy": {
      "boys": ["Finn", "Kai", "Zara", "Orion", "Sage", "River", "Atlas", "Nova"],
      "girls": ["Luna", "Aria", "Sage", "Nova", "Ivy", "Ember", "Wren", "Skye"]
    },
    "adventure": {
      "boys": ["Max", "Leo", "Sam", "Jake", "Ben", "Cole", "Drew", "Ryan"],
      "girls": ["Zoe", "Maya", "Lily", "Emma", "Sophie", "Chloe", "Mia", "Ava"]
    },
    "mystery": {
      "boys": ["Oliver", "Henry", "Arthur", "Felix", "Oscar", "Hugo", "Theo", "Miles"],
      "girls": ["Violet", "Ruby", "Hazel", "Iris", "Pearl", "Rose", "Grace", "Belle"]
    },
    "science": {
      "boys": ["Parker", "Quinn", "Atlas", "Neo", "Zach", "Kai", "Ravi", "Sage"],
      "girls": ["Nova", "Luna", "Vera", "Ada", "Zara", "Sky", "Nora", "Iris"]
    },
    "friendship": {
      "boys": ["Charlie", "Jamie", "Alex", "Sam", "Casey", "Jordan", "Riley", "Taylor"],
      "girls": ["Lily", "Grace", "Emma", "Sofia", "Chloe", "Maya", "Zoe", "Mia"]
    }
  },
  "age_bands": {
    "pre_k": {
      "label": "Pre-K (3-5 years)",
      "safety": ["no peril","no fear","always bright, friendly expressions","no brand/logos"]
    },
    "kids": {
      "label": "Kids (6-8 years)", 
      "safety": ["very light suspense OK","no realistic injuries","mild spooky limited (soft lighting only)"]
    },
    "tweens": {
      "label": "Tweens (9-12 years)",
      "safety": ["moderate stakes OK (mystery/conflict without harm)","still no gore/weapons"]
    }
  }
};

module.exports = { RULES };
