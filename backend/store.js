// store.js
// In-memory (swap to Redis/DB for production)
const BOOK_SESSIONS = global.BOOK_SESSIONS ||= {};

function getBook(book_id) { return BOOK_SESSIONS[book_id]; }
function putBook(book_id, payload) { BOOK_SESSIONS[book_id] = payload; return payload; }

// NEW: outline + pages memory
function setOutline(book_id, outline) { if (!BOOK_SESSIONS[book_id]) return; BOOK_SESSIONS[book_id].outline = outline; }
function getOutline(book_id) { return BOOK_SESSIONS[book_id]?.outline || []; }

function pushPage(book_id, page, lines, scene_hint) {
  if (!BOOK_SESSIONS[book_id]) return;
  BOOK_SESSIONS[book_id].pages ||= [];
  BOOK_SESSIONS[book_id].pages[page-1] = { page, lines, scene_hint, ts: Date.now() };
}

function getStorySoFar(book_id) {
  const p = (BOOK_SESSIONS[book_id]?.pages || []).filter(Boolean);
  return p.map(pg => ({ page: pg.page, lines: pg.lines, scene_hint: pg.scene_hint }));
}

module.exports = { getBook, putBook, setOutline, getOutline, pushPage, getStorySoFar };
