// routes/rules.js
function mountRulesRoute(app, RULES) {
  app.get("/api/rules", (req, res) => {
    res.json({
      styles: RULES.styles.map(s => ({ label: s.label, key: s.key })),
      genres: RULES.genres.map(g => ({ label: g.label, key: g.key })),
      raw: RULES
    });
  });
}
module.exports = { mountRulesRoute };
