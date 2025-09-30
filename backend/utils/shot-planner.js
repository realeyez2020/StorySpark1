// utils/shot-planner.js
function pickByWords(text, pairs) {
  const t = text.toLowerCase();
  for (const [regex, value] of pairs) if (regex.test(t)) return value;
  return null;
}

// Map Claude's visual_focus -> camera recipe
const RECIPES = {
  lead_close:        { frame:"close-up", angle:"eye-level",   comp:"rule of thirds", include:["lead"],      exclude:[],        portrait:true  },
  lead_medium:       { frame:"medium",   angle:"eye-level",   comp:"rule of thirds", include:["lead"],      exclude:[],        portrait:false },
  supporting_close:  { frame:"close-up", angle:"eye-level",   comp:"clean headroom", include:["support"],   exclude:[],        portrait:true  },
  group_wide:        { frame:"wide",     angle:"eye-level",   comp:"balanced crowd", include:["group"],     exclude:["lead?"],portrait:false },
  environment_estab: { frame:"wide",     angle:"slight high", comp:"leading lines",  include:["environment"],exclude:["lead?"],portrait:false },
  object_macro:      { frame:"macro",    angle:"eye-level",   comp:"center hero",    include:["object"],    exclude:["portraits"], portrait:false }
};

function inferFocusFromText(lines) {
  const text = lines.join(" ");
  return pickByWords(text, [
    [/\bcrowd|neighbors|people|audience|gather|parade|line(s)?\b/i, "group_wide"],
    [/\bstreet|yard|park|city|forest|beach|classroom|house|window\b/i, "environment_estab"],
    [/\bbrush|sandwich|map|toy|nugget|treasure|letter|nest\b/i, "object_macro"],
    [/\bwhisper|thought|feels?|face|tears?|smile|wink\b/i, "lead_close"],
  ]) || "lead_medium";
}

function buildShotPlan({ lines, visual_focus, page }) {
  const focus = visual_focus || inferFocusFromText(lines);
  const base = RECIPES[focus] || RECIPES.lead_medium;

  // gentle alternation if everything looks the same
  if (!visual_focus && page % 4 === 1 && base.frame !== "wide") base.frame = "wide";
  if (!visual_focus && page % 4 === 2 && base.frame !== "close-up") base.frame = "close-up";

  return { focus, ...base };
}

function shotToPrompt(shot, leadName, supportNames=[]) {
  const include = [];
  const exclude = [];

  if (shot.include.includes("lead") && leadName) include.push(`show ${leadName}`);
  if (shot.include.includes("support") && supportNames.length) include.push(`feature ${supportNames[0]}`);
  if (shot.include.includes("group")) include.push("group of neighbors, balanced spacing");
  if (shot.include.includes("environment")) include.push("environmental storytelling; people as small figures");
  if (shot.include.includes("object")) include.push("hero object large in frame, tactile detail");

  if (shot.exclude.includes("lead?") && leadName) exclude.push(`no portrait of ${leadName}`);
  if (shot.exclude.includes("portraits")) exclude.push("no portrait framing");

  const camera = `FRAMING: ${shot.frame}; ANGLE: ${shot.angle}; COMPOSITION: ${shot.comp}`;
  return {
    planLine: `${camera} | ${include.join("; ")}`,
    negatives: exclude
  };
}

module.exports = { buildShotPlan, shotToPrompt };
