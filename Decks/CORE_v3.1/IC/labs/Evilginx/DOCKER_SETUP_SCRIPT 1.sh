#!/usr/bin/env bash

set -e

cd ~/BnB
mkdir -p evilginx
cd evilginx
mkdir -p evilginx_lab

cd evilginx_lab
mkdir -p views
mkdir -p public


cat > .env <<'EOF'
JWT_SECRET=lk12!aj3s4dnfA9K@5LSN0FDI7WU
SECURE_COOKIE=false
PORT=443
DB_PATH=/app/data/lab.db
EOF


cat > Dockerfile <<'EOF'
FROM node:20-bookworm-slim

WORKDIR /app

COPY package.json ./
RUN npm install --omit=dev

COPY . .

RUN mkdir -p /app/data
EXPOSE 443

CMD ["npm", "start"]
EOF


cat > package.json <<'EOF'
{
  "name": "evilginx-express-lab",
  "version": "1.0.0",
  "description": "Simple Express authentication demo site.",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "bcryptjs": "^2.4.3",
    "cookie-parser": "^1.4.6",
    "ejs": "^3.1.10",
    "express": "^4.18.3",
    "jsonwebtoken": "^9.0.2",
    "sqlite3": "^5.1.7"
  }
}
EOF


cat > server.js <<'EOF'
const express = require("express");
const path = require("path");
const sqlite3 = require("sqlite3").verbose();
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const fs = require("fs");
const https = require("https");
const cookieParser = require("cookie-parser");

const app = express();

const PORT = process.env.PORT || 443;
const JWT_SECRET = process.env.JWT_SECRET || "lk12!aj3s4dnfA9K@5LSN0FDI7WU";
const COOKIE_NAME = "training_session";
const SECURE_COOKIE = process.env.SECURE_COOKIE === "true";

const dbPath = path.join(__dirname, "data", "lab.db");
const db = new sqlite3.Database(dbPath);

db.serialize(() => {
  db.run(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      full_name TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password_hash TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `);
});

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));

app.use(express.urlencoded({ extended: false }));
app.use(express.json());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));

function createToken(user) {
  return jwt.sign(
    {
      sub: user.id,
      email: user.email,
      name: user.full_name,
      purpose: "security-awareness-lab"
    },
    JWT_SECRET,
    { expiresIn: "30m" }
  );
}

function authRequired(req, res, next) {
  const token = req.cookies[COOKIE_NAME];

  if (!token) {
    return res.redirect("/login");
  }

  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch (err) {
    res.clearCookie(COOKIE_NAME);
    return res.redirect("/login");
  }
}

app.get("/", (req, res) => {
  res.render("index");
});

app.get("/register", (req, res) => {
  res.render("register", { error: null, success: null });
});

app.post("/register", async (req, res) => {
  const { full_name, email, password } = req.body;

  if (!full_name || !email || !password) {
    return res.status(400).render("register", {
      error: "Please complete all fields.",
      success: null
    });
  }

  if (password.length < 6) {
    return res.status(400).render("register", {
      error: "Password must be at least 6 characters.",
      success: null
    });
  }

  try {
    const passwordHash = await bcrypt.hash(password, 10);

    db.run(
      "INSERT INTO users (full_name, email, password_hash) VALUES (?, ?, ?)",
      [full_name, email.toLowerCase(), passwordHash],
      function (err) {
        if (err) {
          return res.status(400).render("register", {
            error: "This email is already registered.",
            success: null
          });
        }

        return res.render("register", {
          error: null,
          success: "Account created. You can now log in."
        });
      }
    );
  } catch (err) {
    return res.status(500).render("register", {
      error: "Something went wrong.",
      success: null
    });
  }
});

app.get("/login", (req, res) => {
  res.render("login", { error: null });
});

app.post("/login", (req, res) => {
  const { email, password } = req.body;

  db.get(
    "SELECT * FROM users WHERE email = ?",
    [String(email || "").toLowerCase()],
    async (err, user) => {
      if (err || !user) {
        return res.status(401).render("login", {
          error: "Invalid email or password."
        });
      }

      const validPassword = await bcrypt.compare(password || "", user.password_hash);

      if (!validPassword) {
        return res.status(401).render("login", {
          error: "Invalid email or password."
        });
      }

      const token = createToken(user);

      res.cookie(COOKIE_NAME, token, {
        httpOnly: true,
        secure: SECURE_COOKIE,
        sameSite: "lax",
        maxAge: 30 * 60 * 1000,
        path: "/"
      });

      return res.redirect("/dashboard");
    }
  );
});

app.get("/dashboard", authRequired, (req, res) => {
  res.render("dashboard", { user: req.user });
});

app.post("/logout", (req, res) => {
  res.clearCookie(COOKIE_NAME, { path: "/" });
  res.redirect("/");
});

const httpsOptions = {
  key: fs.readFileSync(path.join(__dirname, "certs", "cloudservice.key")),
  cert: fs.readFileSync(path.join(__dirname, "certs", "cloudservice.crt"))
};

https.createServer(httpsOptions, app).listen(PORT, "0.0.0.0", () => {
  console.log(`CloudDesk site running on https://0.0.0.0:${PORT}`);
  console.log(`SQLite database: ${dbPath}`);
});
EOF


cat > ./public/style.css <<'EOF'
:root {
  --bg: #f4f7fb;
  --card: #ffffff;
  --text: #172033;
  --muted: #657389;
  --blue: #2563eb;
  --blue-dark: #1d4ed8;
  --border: #dde5f0;
  --soft-blue: #eaf1ff;
  --green: #0f766e;
  --red: #b42318;
}

* { box-sizing: border-box; }

body {
  margin: 0;
  font-family: Arial, Helvetica, sans-serif;
  background: var(--bg);
  color: var(--text);
}

.nav {
  height: 72px;
  padding: 0 42px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.brand {
  text-decoration: none;
  font-size: 23px;
  font-weight: 800;
  color: var(--text);
}

.nav-links {
  display: flex;
  align-items: center;
  gap: 18px;
}

.nav-links a {
  text-decoration: none;
  color: var(--muted);
  font-weight: 700;
}

.nav-button {
  background: var(--text);
  color: white !important;
  padding: 10px 16px;
  border-radius: 10px;
}

.home {
  max-width: 1180px;
  margin: 0 auto;
  padding: 50px 24px 80px;
}

.hero {
  display: grid;
  grid-template-columns: 1.1fr 0.9fr;
  gap: 38px;
  align-items: center;
}

.eyebrow {
  display: inline-block;
  margin: 0 0 16px;
  color: var(--blue);
  background: var(--soft-blue);
  padding: 8px 13px;
  border-radius: 999px;
  font-size: 14px;
  font-weight: 800;
}

h1 {
  margin: 0;
  font-size: 48px;
  line-height: 1.08;
  letter-spacing: -1px;
}

.lead {
  margin: 22px 0 0;
  color: var(--muted);
  font-size: 18px;
  line-height: 1.65;
  max-width: 650px;
}

.actions {
  margin-top: 32px;
  display: flex;
  gap: 14px;
}

.button {
  border: 0;
  border-radius: 12px;
  padding: 14px 22px;
  text-decoration: none;
  font-weight: 800;
  font-size: 16px;
  cursor: pointer;
  display: inline-block;
}

.primary {
  background: var(--blue);
  color: white;
}

.primary:hover { background: var(--blue-dark); }

.secondary {
  background: #e3e9f3;
  color: var(--text);
}

.full {
  width: 100%;
  margin-top: 18px;
}

.panel {
  background: var(--card);
  border: 1px solid var(--border);
  border-radius: 24px;
  box-shadow: 0 18px 48px rgba(30, 41, 59, 0.12);
  padding: 24px;
}

.panel-header {
  display: flex;
  gap: 7px;
  margin-bottom: 22px;
}

.panel-header span {
  width: 11px;
  height: 11px;
  background: #d5deeb;
  border-radius: 50%;
}

.storage-card {
  background: #f7faff;
  border: 1px solid var(--border);
  border-radius: 18px;
  padding: 18px;
  margin-bottom: 16px;
}

.storage-card p,
.file-row p {
  margin: 5px 0 0;
  color: var(--muted);
  font-size: 14px;
}

.meter {
  height: 9px;
  background: #dce6f5;
  border-radius: 999px;
  margin-top: 15px;
  overflow: hidden;
}

.meter div {
  width: 56%;
  height: 100%;
  background: var(--blue);
}

.file-row {
  display: flex;
  align-items: center;
  gap: 14px;
  border: 1px solid var(--border);
  border-radius: 16px;
  padding: 15px;
  margin-top: 12px;
}

.file-icon {
  background: var(--soft-blue);
  color: var(--blue);
  font-weight: 900;
  border-radius: 12px;
  padding: 10px 9px;
  font-size: 13px;
}

.features {
  margin-top: 42px;
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 18px;
}

.features div,
.dash-card,
.welcome-card,
.auth-card {
  background: var(--card);
  border: 1px solid var(--border);
  border-radius: 20px;
  padding: 26px;
  box-shadow: 0 12px 32px rgba(30, 41, 59, 0.07);
}

.features h2,
.dash-card h2 {
  margin: 0 0 10px;
  font-size: 20px;
}

.features p,
.dash-card p {
  margin: 0;
  color: var(--muted);
  line-height: 1.55;
}

.auth-page {
  min-height: calc(100vh - 72px);
  display: grid;
  place-items: center;
  padding: 28px;
}

.auth-card {
  width: 100%;
  max-width: 430px;
}

.auth-card h1 {
  font-size: 34px;
}

.auth-subtitle {
  color: var(--muted);
  line-height: 1.5;
  margin-bottom: 24px;
}

form label {
  display: block;
  margin: 16px 0 7px;
  font-weight: 800;
}

input {
  width: 100%;
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 14px;
  font-size: 16px;
  outline: none;
}

input:focus { border-color: var(--blue); }

.alert {
  border-radius: 12px;
  padding: 13px 14px;
  margin: 15px 0;
  font-weight: 700;
}

.error {
  background: #fff1f0;
  color: var(--red);
  border: 1px solid #ffd1cc;
}

.success {
  background: #ecfdf5;
  color: var(--green);
  border: 1px solid #bbf7d0;
}

.switch-link {
  text-align: center;
  color: var(--muted);
}

.switch-link a {
  color: var(--blue);
  font-weight: 800;
}

.dashboard {
  max-width: 1050px;
  margin: 0 auto;
  padding: 44px 24px 80px;
}

.welcome-card h1 { font-size: 40px; }

.dashboard-grid {
  margin-top: 22px;
  display: grid;
  grid-template-columns: 1.2fr 1fr 1fr;
  gap: 18px;
}

.simple-list {
  padding: 0;
  margin: 0;
  list-style: none;
}

.simple-list li {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  border-bottom: 1px solid var(--border);
  padding: 12px 0;
}

.simple-list li:last-child { border-bottom: 0; }

.simple-list span { color: var(--muted); }

.logout-button {
  border: 0;
  border-radius: 10px;
  background: #e3e9f3;
  color: var(--text);
  padding: 10px 16px;
  font-weight: 800;
  cursor: pointer;
}

@media (max-width: 850px) {
  .nav { padding: 0 22px; }
  .hero,
  .features,
  .dashboard-grid {
    grid-template-columns: 1fr;
  }
  h1 { font-size: 38px; }
  .actions { flex-direction: column; }
}
EOF


cat > ./views/dashboard.ejs <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Dashboard - CloudDesk</title>
  <link rel="stylesheet" href="/style.css" />
</head>
<body>
  <nav class="nav">
    <a class="brand" href="/">CloudDesk</a>
    <form method="POST" action="/logout">
      <button class="logout-button" type="submit">Log out</button>
    </form>
  </nav>

  <main class="dashboard">
    <section class="welcome-card">
      <p class="eyebrow">Dashboard</p>
      <h1>Welcome, <%= user.name %></h1>
      <p class="lead">Your session is active. This page is only visible with a valid session cookie.</p>
    </section>

    <section class="dashboard-grid">
      <div class="dash-card">
        <h2>Recent files</h2>
        <ul class="simple-list">
          <li>Quarterly_Report.pdf <span>Today</span></li>
          <li>Project_Notes.docx <span>Yesterday</span></li>
          <li>Design_Mockup.png <span>Private</span></li>
        </ul>
      </div>

      <div class="dash-card">
        <h2>Account details</h2>
        <p><strong>Email:</strong> <%= user.email %></p>
        <p><strong>Session:</strong> Active</p>
        <p><strong>Token type:</strong> JWT cookie</p>
      </div>

      <div class="dash-card">
        <h2>Security notice</h2>
        <p>
          Your account session is active. Always check the website address before entering your credentials.
        </p>
      </div>
    </section>
  </main>
</body>
</html>
EOF


cat > ./views/index.ejs <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>CloudDesk</title>
  <link rel="stylesheet" href="/style.css" />
</head>
<body>
  <nav class="nav">
    <a class="brand" href="/">CloudDesk</a>
    <div class="nav-links">
      <a href="/login">Sign in</a>
      <a href="/register" class="nav-button">Create account</a>
    </div>
  </nav>

  <main class="home">
    <section class="hero">
      <div class="hero-content">
        <p class="eyebrow">Secure cloud workspace</p>
        <h1>Your files, notes, and projects in one simple place.</h1>
        <p class="lead">
          Demo Workspace is a lightweight personal workspace for storing documents,
          tracking projects, and accessing your dashboard from anywhere.
        </p>

        <div class="actions">
          <a href="/register" class="button primary">Get started</a>
          <a href="/login" class="button secondary">Sign in</a>
        </div>
      </div>

      <div class="panel">
        <div class="panel-header">
          <span></span><span></span><span></span>
        </div>

        <div class="storage-card">
          <div>
            <strong>Storage</strong>
            <p>8.4 GB of 15 GB used</p>
          </div>
          <div class="meter">
            <div></div>
          </div>
        </div>

        <div class="file-row">
          <span class="file-icon">PDF</span>
          <div>
            <strong>Quarterly_Report.pdf</strong>
            <p>Updated today</p>
          </div>
        </div>

        <div class="file-row">
          <span class="file-icon">DOC</span>
          <div>
            <strong>Project_Notes.docx</strong>
            <p>Shared with you</p>
          </div>
        </div>

        <div class="file-row">
          <span class="file-icon">IMG</span>
          <div>
            <strong>Design_Mockup.png</strong>
            <p>Private</p>
          </div>
        </div>
      </div>
    </section>

    <section class="features">
      <div>
        <h2>Simple dashboard</h2>
        <p>Access a clean account area after login.</p>
      </div>
      <div>
        <h2>Protected session</h2>
        <p>Your browser receives a session cookie after authentication.</p>
      </div>
      <div>
        <h2>Easy account setup</h2>
        <p>Create a temporary demo account and access your personal workspace.</p>
      </div>
    </section>
  </main>
</body>
</html>
EOF


cat > ./views/login.ejs <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Sign in - CloudDesk</title>
  <link rel="stylesheet" href="/style.css" />
</head>
<body>
  <nav class="nav">
    <a class="brand" href="/">CloudDesk</a>
    <div class="nav-links">
      <a href="/register">Create account</a>
    </div>
  </nav>

  <main class="auth-page">
    <section class="auth-card">
      <p class="eyebrow">Welcome back</p>
      <h1>Sign in to your workspace</h1>
      <p class="auth-subtitle">Enter your lab account credentials.</p>

      <% if (error) { %>
        <div class="alert error"><%= error %></div>
      <% } %>

      <form method="POST" action="/login">
        <label for="email">Email address</label>
        <input id="email" name="email" type="email" placeholder="name@example.test" required />

        <label for="password">Password</label>
        <input id="password" name="password" type="password" placeholder="Your password" required />

        <button type="submit" class="button primary full">Sign in</button>
      </form>

      <p class="switch-link">No account yet? <a href="/register">Create one</a></p>
    </section>
  </main>
</body>
</html>
EOF


cat > ./views/register.ejs <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Create account - CloudDesk</title>
  <link rel="stylesheet" href="/style.css" />
</head>
<body>
  <nav class="nav">
    <a class="brand" href="/">CloudDesk</a>
    <div class="nav-links">
      <a href="/login">Sign in</a>
    </div>
  </nav>

  <main class="auth-page">
    <section class="auth-card">
      <p class="eyebrow">Create account</p>
      <h1>Start using CloudDesk</h1>
      <p class="auth-subtitle">Use fake details only for this controlled lab.</p>

      <% if (error) { %>
        <div class="alert error"><%= error %></div>
      <% } %>

      <% if (success) { %>
        <div class="alert success"><%= success %></div>
      <% } %>

      <form method="POST" action="/register">
        <label for="full_name">Full name</label>
        <input id="full_name" name="full_name" type="text" placeholder="Your Name" required />

        <label for="email">Email address</label>
        <input id="email" name="email" type="email" placeholder="name@example.test" required />

        <label for="password">Password</label>
        <input id="password" name="password" type="password" placeholder="Minimum 6 characters" required />

        <button type="submit" class="button primary full">Create account</button>
      </form>

      <p class="switch-link">Already have an account? <a href="/login">Sign in</a></p>
    </section>
  </main>
</body>
</html>
EOF


mkdir -p certs

openssl genrsa -out certs/lab-ca.key 4096


openssl req -x509 -new -nodes \
  -key certs/lab-ca.key \
  -sha256 \
  -days 365 \
  -out certs/lab-ca.crt \
  -subj "/CN=CloudService Lab CA"


cat > certs/cloudservice.cnf <<'EOF'
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = cloudservice.com

[v3_req]
subjectAltName = @alt_names

[alt_names]
DNS.1 = cloudservice.com
EOF


openssl genrsa -out certs/cloudservice.key 2048


openssl req -new \
  -key certs/cloudservice.key \
  -out certs/cloudservice.csr \
  -config certs/cloudservice.cnf


openssl x509 -req \
  -in certs/cloudservice.csr \
  -CA certs/lab-ca.crt \
  -CAkey certs/lab-ca.key \
  -CAcreateserial \
  -out certs/cloudservice.crt \
  -days 365 \
  -sha256 \
  -extensions v3_req \
  -extfile certs/cloudservice.cnf


openssl x509 -in certs/cloudservice.crt -noout -subject -ext subjectAltName


sudo cp certs/lab-ca.crt /usr/local/share/ca-certificates/cloudservice-lab-ca.crt

sudo update-ca-certificates


mkdir -p ~/cloudservice-site/certs

openssl req -x509 -nodes -newkey rsa:2048 -sha256 -days 365 \
  -keyout ~/cloudservice-site/certs/cloudservice.key \
  -out ~/cloudservice-site/certs/cloudservice.crt \
  -subj "/CN=cloudservice.com" \
  -addext "subjectAltName=DNS:cloudservice.com"


sudo docker build -t evilginx-lab .