'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "3bf363f0849e6711594926369c64b450",
"assets/AssetManifest.bin.json": "b8030d2b33f7c855facaf62988ae9073",
"assets/AssetManifest.json": "a7c42e12cdb92d4fd1504fe02f283bc0",
"assets/assets/images/bottomimag1.png": "0ca5ceee83a43e94f44bbf331b150122",
"assets/assets/images/bottomimage.png": "0ca5ceee83a43e94f44bbf331b150122",
"assets/assets/images/google_logo_icon.png": "206438fa5bf135a3ed09d9ac810a5bb4",
"assets/assets/images/icon_sample.png": "5435575127e26072ade627288a8d3167",
"assets/assets/images/img1.png": "d955af204bd8ee65096704004ae0cb3d",
"assets/assets/images/img10.png": "e6a11628c36fd1a6584312e542651007",
"assets/assets/images/img2.png": "dfa7b76fb49e76f86e18cc1db3e3d487",
"assets/assets/images/img3.png": "1ccb07929d3813b17aa87eece48c3d27",
"assets/assets/images/img4.png": "8d5dd73fe41c3ffbf20a0e9b7767ef0c",
"assets/assets/images/img5.png": "f443fdca887e312dd14d73d7d298a571",
"assets/assets/images/img6.png": "218a745859d75bf1adcddd342ac68879",
"assets/assets/images/img7.png": "12b76b07b350e6e61c3eb5c3489d1ece",
"assets/assets/images/img8.png": "1fdc2ae23486039f55aa6c9fb6f4fd12",
"assets/assets/images/img9.png": "604089fcc73adf5744de776ba22579d0",
"assets/assets/images/img_loga.png": "d955af204bd8ee65096704004ae0cb3d",
"assets/assets/images/mynukaadd.png": "e5f14e5308f77bbd55f7a3e627ad05d9",
"assets/assets/images/notmynuka.png": "525f7eb7c31f55c86e8d6514eff70dd1",
"assets/assets/images/toplogo.png": "7ad61770c9e1ca72a017e57bc06443e2",
"assets/assets/images/veg1.png": "b2d8a34caf55c5d15d5be96f4389cd04",
"assets/assets/images/veg10.png": "aaeacd12d6fb69e78c6bace98a10c810",
"assets/assets/images/veg2.png": "eb5a1a3fc3dc9542c67640dac743a68d",
"assets/assets/images/veg3.png": "3cd820f0602123cd58d3bc234f4c7b94",
"assets/assets/images/veg4.png": "18efee337399146286994c4011d1006d",
"assets/assets/images/veg5.png": "5d85cec664476dfea7180e2c0fb2a368",
"assets/assets/images/veg6.png": "933d9ebfcb8f407e7a58d30cd2a023c7",
"assets/assets/images/veg7.png": "5981e8e8feb2c603ed66a25ee11b9638",
"assets/assets/images/veg8.png": "506030448b56bc5d8ea385e8a100a05f",
"assets/assets/images/veg9.png": "eb97319b0f17f1b6e73edc3f0ca20b05",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "caa17574a11a4b171309727760b74903",
"assets/NOTICES": "6154bb054d3db5ee4b260074d8be6071",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "577b8c614c51396fd7399bf223942419",
"/": "577b8c614c51396fd7399bf223942419",
"main.dart.js": "ed78e6a8d78cdc5cc481278aa27b1017",
"manifest.json": "8a313bd18c9c92c9fbef36df02ea80dd",
"version.json": "782e07cc58cbbb8d46c8432c56c58fed"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
