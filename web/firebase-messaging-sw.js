// web/firebase-messaging-sw.js

// Use the compat builds in a service worker (simplest + works everywhere)
importScripts('https://www.gstatic.com/firebasejs/10.14.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.14.0/firebase-messaging-compat.js');

// Copy your web config from Firebase console (NOT the Dart options object)
firebase.initializeApp({
  apiKey: "AIzaSyDvEsztETqHYAwfJx0ocpjPTZccMNDMc-k",
  authDomain: "tranquil-life-llc.firebaseapp.com",
  projectId: "tranquil-life-llc",
  storageBucket: "tranquil-life-llc.appspot.com",
  messagingSenderId: "16125004014",
  appId: "1:16125004014:web:1a1ccb278c740a6d5f8bff",
});

// Retrieve an instance of Firebase Messaging
const messaging = firebase.messaging();

// Optional: show a notification when a background message arrives
messaging.onBackgroundMessage((payload) => {
  // Customize as you like
  const title = payload.notification?.title || 'Background Message';
  const options = {
    body: payload.notification?.body || '',
    icon: '/icons/app_icon.png',
    data: payload.data || {},
  };
  self.registration.showNotification(title, options);
});
