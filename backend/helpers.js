// helpers.js
function mapStyleLabel(label="") {
  const t = label.toLowerCase();
  if (t.includes("disney") || t.includes("pixar") || t.includes("3d")) return "cinematic_3d_family";
  if (t.includes("manga"))   return "manga_bw";
  if (t.includes("anime"))   return "anime_tv";
  if (t.includes("watercolor") || t.includes("classic")) return "watercolor_storybook";
  if (t.includes("cartoon")) return "cartoony_cutout";
  if (t.includes("comic"))   return "comic_color";
  if (t.includes("fairy"))   return "storybook_ornate";
  if (t.includes("modern"))  return "flat_minimal";
  if (t.includes("pop"))     return "pop_halftone";
  if (t.includes("vintage")) return "vintage_print";
  return "watercolor_storybook";
}

function mapGenreLabel(label="") {
  const t = label.toLowerCase();
  if (t.includes("fantasy"))   return "fantasy";
  if (t.includes("adventure")) return "adventure";
  if (t.includes("space"))     return "space";
  if (t.includes("friend"))    return "friendship";
  if (t.includes("animal"))    return "animals";
  if (t.includes("mystery"))   return "mystery";
  if (t.includes("educ"))      return "educational";
  if (t.includes("bed"))       return "bedtime";
  return "fantasy";
}

function extractKeywords(lines=[]) {
  const text = lines.join(" ");
  const words = (text.toLowerCase().match(/\b[a-z']{3,}\b/g) || [])
    .filter(w => !["the","and","with","from","into","then","that","this","they","were","went","there","said","very","really","just"].includes(w));
  return Array.from(new Set(words)).slice(0, 22);
}

module.exports = { mapStyleLabel, mapGenreLabel, extractKeywords };
