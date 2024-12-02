const CACHE_NAME = 'flutter-app-v1';  // Name your cache
const CRITICAL_FILES = [
    '/',  // Home page
    '/index.html',  // Main HTML page
    '/main.dart.js',  // Main Dart JS file
    '/manifest.json',  // Manifest file
    '/icons/Icon-192.png',  // 192x192 icon
    '/icons/Icon-512.png',  // 512x512 icon
    '/screenshots/pic1.png',  // Add pic1.png from screenshots folder
    '/screenshots/pic2.png'   // Add pic2.png from screenshots folder
];

// Install the service worker and cache critical files
self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            return cache.addAll(CRITICAL_FILES);  // Add the critical files to the cache
        })
    );
});

// Handle fetch requests and serve from cache or network
self.addEventListener('fetch', (event) => {
    event.respondWith(
        caches.match(event.request).then((response) => {
            if (response) {
                return response;  // Return cached response if available
            }
            return fetch(event.request);  // Otherwise, fetch from network
        })
    );
});

// Activate the service worker and clean old caches
self.addEventListener('activate', (event) => {
    const cacheWhitelist = [CACHE_NAME];  // List of caches to keep
    event.waitUntil(
        caches.keys().then((cacheNames) => {
            return Promise.all(
                cacheNames.map((cacheName) => {
                    if (!cacheWhitelist.includes(cacheName)) {
                        return caches.delete(cacheName);  // Delete old caches
                    }
                })
            );
        })
    );
});
