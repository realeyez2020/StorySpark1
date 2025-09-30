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

// Helper functions
function mapStyleLabel(label) {
  const style = RULES.styles.find(s => s.label === label);
  return style ? style.key : 'watercolor_storybook';
}

function mapGenreLabel(label) {
  const genre = RULES.genres.find(g => g.label === label);
  return genre ? genre.key : 'fantasy';
}

function shouldRhyme(genreKey, forceRhyme) {
  if (forceRhyme !== undefined) return forceRhyme;
  const genre = RULES.genres.find(g => g.key === genreKey);
  return genre ? genre.rhyme_default : false;
}

function extractKeywords(lines) {
  const text = lines.join(" ");
  const words = Array.from(text.matchAll(/\b([A-Za-z']{3,})\b/g)).map(m => m[1].toLowerCase())
    .filter(w => !["the","and","but","with","from","into","then","that","this","they","were","went","there","said"].includes(w));
  return Array.from(new Set(words)).slice(0, 20);
}

function generateCharacterName(genreKey, gender = null) {
  // Map genre key to name category
  const nameCategory = genreKey === 'fantasy' ? 'fantasy' :
                      genreKey === 'adventure' ? 'adventure' :
                      genreKey === 'mystery' ? 'mystery' :
                      genreKey === 'sci_fi' ? 'science' : 'friendship';
  
  const names = RULES.character_names[nameCategory];
  if (!names) return gender === 'girl' ? 'Luna' : 'Sam';
  
  // Random gender if not specified
  const selectedGender = gender || (Math.random() > 0.5 ? 'boys' : 'girls');
  const namePool = names[selectedGender] || names.boys;
  
  return namePool[Math.floor(Math.random() * namePool.length)];
}

function buildImageJob({ page, lines, styleLabel, genreLabel, bible, ageBand = 'kids', characters = [] }) {
  const styleKey = mapStyleLabel(styleLabel);
  const genreKey = mapGenreLabel(genreLabel);
  
  const style = RULES.styles.find(s => s.key === styleKey);
  const genre = RULES.genres.find(g => g.key === genreKey);
  
  if (!style || !genre) {
    throw new Error(`Invalid style or genre: ${styleLabel}, ${genreLabel}`);
  }
  
  const keywords = extractKeywords(lines);
  const ageOverride = genre.age_overrides?.[ageBand] || [];
  
  const negatives = [
    ...(style.negatives || []),
    ...(ageBand === 'pre_k' ? ['no dark scary lighting', 'no threatening expressions'] : []),
    ...ageOverride.filter(rule => rule.startsWith('no ')),
    'no style changes', 'no character design changes', 'no lighting variations', 
    'no different art techniques', 'no color palette changes', 'no costume changes',
    'no age changes', 'no hair changes', 'no face changes', 'no proportional changes'
  ];

  const characterName = Object.keys(bible?.character_bible || {})[0] || 'Alex';
  const characterDesc = bible?.character_bible?.[characterName];
  
  const prompt = [
    style.base,
    'ABSOLUTE CHARACTER BIBLE ENFORCEMENT:',
    characterDesc ? `${characterName}: ${characterDesc.appearance}, ${characterDesc.clothing}, ${characterDesc.body_type}. ${characterDesc.STRICT_RULE}` : `Alex: 8-year-old child with short brown hair, purple hoodie and blue jeans - IDENTICAL in every page`,
    bible?.style_bible?.art_consistency ? `ART BIBLE: ${bible.style_bible.art_consistency}` : 'ART LOCKED: same illustration style, lighting, color palette throughout entire book',
    bible?.book_meta?.palette ? `PALETTE ENFORCED: ${bible.book_meta.palette.join(', ')} only` : 'PALETTE: purple, gold, emerald, silver, rose tones only',
    bible?.book_meta?.camera_height ? `CAMERA FIXED: ${bible.book_meta.camera_height}` : 'CAMERA: child-eye level perspective only',
    'ABSOLUTE FORBIDDEN: style changes, character design changes, lighting variations, costume changes, age changes, hair changes, face changes',
    'scene keywords:', keywords.join(', '),
    bible?.book_meta?.lighting ? `LIGHTING LOCKED: ${bible.book_meta.lighting}` : 'LIGHTING: warm natural lighting only',
    style.quality ? ['QUALITY LOCKED:', ...style.quality].join(' ') : '',
    style.technique ? ['TECHNIQUE LOCKED:', ...style.technique].join(' ') : ''
  ].filter(Boolean).join(' | ');

  return {
    prompt,
    negatives: negatives.join('; '),
    style_key: styleKey,
    genre_key: genreKey
  };
}

// Rules endpoint
app.get('/api/rules', (req, res) => {
  res.json(RULES);
});

// Complete story generation endpoint  
app.post('/api/story/complete', async (req, res) => {
  const { idea, category, story_bible, force_rhyme, age_band = 'kids', num_pages = 5 } = req.body;
  
  const genreKey = mapGenreLabel(category);
  const genre = RULES.genres.find(g => g.key === genreKey);
  const rhyme = shouldRhyme(genreKey, force_rhyme);
  
  if (!genre) {
    return res.status(400).json({ error: `Unknown genre: ${category}` });
  }
  
  const characterName = story_bible?.characters?.[0]?.name || 'Alex';
  const characterInfo = story_bible?.characters?.[0] || {};
  
  const rhymeInstruction = rhyme ? 'Use AABB rhyme scheme with 2–4 lines per page.' : 'Write in simple, clear prose without rhyming.';
  const toneInstruction = `Tone: ${genre.tone.join(', ')}.`;
  const mustInclude = genre.must_include ? `Must include: ${genre.must_include.join(', ')}.` : '';
  const banIntros = genre.ban_intros ? `NEVER start with: ${RULES.ban_cliche_openers.join(', ')}.` : '';
  
  const system = `You are a children's picture-book author. Write a complete ${num_pages}-page story for ${age_band} audience. ${genre.voice.tense} tense, ${genre.voice.pov} person. ${toneInstruction} ${rhymeInstruction} ${mustInclude} ${banIntros}

STRICT CHARACTER CONSISTENCY: Use "${characterName}" as the main character throughout the entire story. ${characterInfo.description || 'curious 8-year-old'}. Character must stay exactly the same in appearance and personality.

FORBIDDEN OPENINGS: ${story_bible?.anti_cliche || 'Never use Once upon a time, Long ago, In a land far away, There once was'}

Write a cohesive story with proper flow and continuity. Keep continuity with Story Bible: names, outfits, setting. Avoid brands/violence/fear.`;

  try {
    if (!ANTHROPIC_API_KEY) {
      throw new Error('ANTHROPIC_API_KEY is not configured. Please add it to your .env file.');
    }

    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'x-api-key': ANTHROPIC_API_KEY,
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'claude-sonnet-4-20250514',
        max_tokens: 2048,
        messages: [
          { 
            role: 'user', 
            content: `${system}\n\nStory Bible: ${JSON.stringify(story_bible)}\n\nWrite a complete story for idea/category: ${category} / ${idea}\n\nReturn JSON with:\n{\n  "title": "Story Title",\n  "character": {"name": "${characterName}", "description": "full description"},\n  "pages": [\n    {\n      "page": 1,\n      "lines": ["line 1", "line 2"],\n      "scene_hint": "visual description for this page"\n    },\n    ...(repeat for ${num_pages} pages)\n  ]\n}\n\nReturn ONLY the JSON object.` 
          }
        ],
      }),
    });

    const data = await response.json();
    console.log('Claude Complete Story Response:', JSON.stringify(data, null, 2));
    
    if (!data.content || data.content.length === 0) {
      console.error('No content in Claude response:', data);
      throw new Error('Invalid Claude response: ' + JSON.stringify(data));
    }
    
    let rawText = data.content[0].text;
    rawText = rawText.replace(/```json\s*/, '').replace(/```\s*$/, '');
    rawText = rawText.replace(/^Here's the JSON.*?:\s*/s, '');
    rawText = rawText.replace(/^.*?({.*}).*$/s, '$1');
    rawText = rawText.trim();
    
    console.log('Cleaned Complete Story:', rawText);
    
    const content = JSON.parse(rawText);
    res.json(content);
  } catch (error) {
    console.error('Complete story generation error:', error);
    res.status(500).json({ error: 'Failed to generate complete story' });
  }
});

// Single page generation endpoint (for extending stories)
app.post('/api/story', async (req, res) => {
  const { page, idea, category, story_bible, force_rhyme, age_band = 'kids' } = req.body;
  
  const genreKey = mapGenreLabel(category);
  const genre = RULES.genres.find(g => g.key === genreKey);
  const rhyme = shouldRhyme(genreKey, force_rhyme);
  
  if (!genre) {
    return res.status(400).json({ error: `Unknown genre: ${category}` });
  }
  
  const rhymeInstruction = rhyme ? 'Use AABB rhyme scheme with 2–4 lines per page.' : 'Write in simple, clear prose without rhyming.';
  const toneInstruction = `Tone: ${genre.tone.join(', ')}.`;
  const mustInclude = genre.must_include ? `Must include: ${genre.must_include.join(', ')}.` : '';
  const banIntros = genre.ban_intros ? `NEVER start with: ${RULES.ban_cliche_openers.join(', ')}.` : '';
  
  const characterName = story_bible?.characters?.[0]?.name || 'Alex';
  const characterInfo = story_bible?.characters?.[0] || {};
  
  const system = `You are a children's picture-book author. Write for ${age_band} audience. ${genre.voice.tense} tense, ${genre.voice.pov} person. ${toneInstruction} ${rhymeInstruction} ${mustInclude} ${banIntros}

STRICT CHARACTER CONSISTENCY: Use "${characterName}" as the main character (NOT "Hero"). ${characterInfo.description || 'curious 8-year-old'}. Keep exact same personality and appearance.

FORBIDDEN OPENINGS: ${story_bible?.anti_cliche || 'Never use Once upon a time, Long ago, In a land far away, There once was'}

Keep continuity with Story Bible: names, outfits, setting. Avoid brands/violence/fear. Include a scene_hint field describing the visual scene for this page with the character name "${characterName}".`;

  try {
    if (!ANTHROPIC_API_KEY) {
      throw new Error('ANTHROPIC_API_KEY is not configured. Please add it to your .env file.');
    }

    const response = await fetch('https://api.anthropic.com/v1/messages', {
      method: 'POST',
      headers: {
        'x-api-key': ANTHROPIC_API_KEY,
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'claude-sonnet-4-20250514',
        max_tokens: 1024,
        messages: [
          { 
            role: 'user', 
            content: `${system}\n\nStory Bible: ${JSON.stringify(story_bible)}\n\nWrite page ${page} for idea/category: ${category} / ${idea}\n\nYou MUST return ONLY valid JSON in this exact format:\n{\n  "page": ${page},\n  "lines": ["line 1 text", "line 2 text", "line 3 text"],\n  "scene_hint": "brief visual scene description for illustration",\n  "rhyme_labels": ["A", "B", "C"],\n  "end_words": ["word1", "word2", "word3"],\n  "syllables": [12, 15, 18],\n  "passes_checks": true\n}\n\nDo NOT include any text before or after the JSON. Return ONLY the JSON object.` 
          }
        ],
      }),
    });

    const data = await response.json();
    
    // Log the response for debugging
    console.log('Claude Response:', JSON.stringify(data, null, 2));
    
    if (!data.content || data.content.length === 0) {
      console.error('No content in Claude response:', data);
      throw new Error('Invalid Claude response: ' + JSON.stringify(data));
    }
    
    let rawText = data.content[0].text;
    
    // Clean up Claude's response - extract JSON if wrapped in markdown or text
    rawText = rawText.replace(/```json\s*/, '').replace(/```\s*$/, '');
    rawText = rawText.replace(/^Here's the JSON.*?:\s*/s, '');
    rawText = rawText.replace(/^.*?({.*}).*$/s, '$1');
    rawText = rawText.trim();
    
    console.log('Cleaned Claude text:', rawText);
    
    const content = JSON.parse(rawText);
    res.json(content);
  } catch (error) {
    console.error('Story generation error:', error);
    res.status(500).json({ error: 'Failed to generate story' });
  }
});

// Image generation endpoint (rule-based)
app.post('/api/image', async (req, res) => {
  const { page, lines, styleLabel, genreLabel, art_bible, age_band = 'kids', characters = [] } = req.body;
  
  if (!lines || !styleLabel || !genreLabel) {
    return res.status(400).json({ error: 'Missing required fields: lines, styleLabel, genreLabel' });
  }
  
  try {
    // Build strict image job using rules
    const job = buildImageJob({ 
      page, 
      lines, 
      styleLabel, 
      genreLabel, 
      bible: art_bible, 
      ageBand: age_band, 
      characters 
    });
    
    console.log('Image job:', JSON.stringify(job, null, 2));

    if (!GROK_API_KEY) {
      throw new Error('GROK_API_KEY is not configured. Please add it to your .env file.');
    }

    // Call Grok image API
    const response = await fetch('https://api.x.ai/v1/images/generations', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${GROK_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'grok-2-image-1212',
        prompt: job.prompt,
        n: 1,
        response_format: 'b64_json',
      }),
    });

    const data = await response.json();
    
    // Log the response for debugging
    console.log('DALL-E Response:', JSON.stringify(data, null, 2));
    
    if (!data.data || data.data.length === 0) {
      console.error('No data in Grok response:', data);
      throw new Error('Invalid Grok response: ' + JSON.stringify(data));
    }
    
    const imageB64 = data.data[0].b64_json;
    res.json({ page, image_b64: imageB64 });
  } catch (error) {
    console.error('Image generation error:', error);
    res.status(500).json({ error: 'Failed to generate image' });
  }
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
  console.log(`🚀 StorySpark AI Backend running on port ${PORT}`);
});
