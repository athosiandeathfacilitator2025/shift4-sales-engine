const express = require("express");
const path = require("path");
const fs = require("fs");

const app = express();
const PORT = process.env.PORT || 4200;

app.use(express.static(path.join(__dirname, "public")));

// Catch-all: serve index.html with Supabase credentials injected
app.get("*", (req, res) => {
  const html = fs.readFileSync(path.join(__dirname, "public", "index.html"), "utf8");
  const envScript = `<script>window.SUPABASE_URL="${process.env.SUPABASE_URL || ""}";window.SUPABASE_KEY="${process.env.SUPABASE_KEY || ""}";</script>`;
  res.send(html.replace("</head>", envScript + "</head>"));
});

app.listen(PORT, () => {
  console.log(`\n  Shift4 Sales Engine running at http://localhost:${PORT}\n`);
});
