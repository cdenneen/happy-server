const http = require('http');

const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '0.0.0.0';

const html = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>happy.engineering</title>
  <style>
    body { font-family: sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background: #f5f5f5; }
    .container { text-align: center; }
    h1 { font-size: 3rem; color: #333; }
    p { color: #666; }
  </style>
</head>
<body>
  <div class="container">
    <h1>happy.engineering</h1>
    <p>Self-hosted server is running.</p>
  </div>
</body>
</html>
`;

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/html' });
  res.end(html);
});

server.listen(PORT, HOST, () => {
  console.log(`happy.engineering self-hosted server running on ${HOST}:${PORT}`);
});
