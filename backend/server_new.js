require("dotenv").config();
const express = require("express");
const cors = require("cors");

const { RULES } = require("./rules");
const { mountRulesRoute } = require("./routes/rules");
const { mountBookInitRoute } = require("./routes/book-init");
const { mountStoryRoute } = require("./routes/story-claude");
const { mountImageRoute } = require("./routes/image");

const app = express();
app.use(cors());
app.use(express.json({ limit: "8mb" }));

// Check API keys
if (!process.env.ANTHROPIC_API_KEY) {
  console.warn('⚠️  Warning: Missing ANTHROPIC_API_KEY in environment variables');
}

if (!process.env.GROK_API_KEY) {
  console.warn('⚠️  Warning: Missing GROK_API_KEY in environment variables');
}

// Routes
mountRulesRoute(app, RULES);     // GET  /api/rules
mountBookInitRoute(app, RULES);  // POST /api/book/init
mountStoryRoute(app);            // POST /api/story
mountImageRoute(app, RULES);     // POST /api/image

const port = process.env.PORT || 3001;
app.listen(port, () => console.log(`🚀 StorySpark AI Proxy listening on :${port}`));
