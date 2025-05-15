// This is a simple service worker for PWA support
self.addEventListener('install', function(e) {
  self.skipWaiting();
});

self.addEventListener('activate', function(e) {
  self.clients.claim();
});

// Only use this service worker when Flutter's service worker doesn't load
self.addEventListener('fetch', function(e) {
  // Return the response from the network if available
  e.respondWith(
    fetch(e.request).catch(function() {
      // Fall back to the offline page if network request fails
      return caches.match(e.request).then((response) => {
        return response || caches.match('/');
      });
    })
  );
}); 