const CACHE = 'factory-erp-v1';
const ASSETS = [
  '/', '/index.html', '/receive.html', '/inventory.html',
  '/production.html', '/dispatch.html', '/trace.html',
  '/reports.html', '/master.html', '/qc.html',
  '/css/main.css', '/js/utils.js', '/js/supabase.js'
];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(ASSETS)).catch(()=>{}));
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(keys =>
    Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
  ));
  self.clients.claim();
});

self.addEventListener('fetch', e => {
  if (e.request.url.includes('supabase.co')) return;
  e.respondWith(
    fetch(e.request).catch(() => caches.match(e.request))
  );
});
