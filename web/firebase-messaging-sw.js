importScripts(
  "https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyC9zZ2scypXYQWjYowOw624HrmCR_I5UZg",
  appId: "1:1041057820042:web:47df1b68cffa6754bdac73",
  messagingSenderId: "1041057820042",
  projectId: "bro-app-ef8ef",
  authDomain: "bro-app-ef8ef.firebaseapp.com",
  storageBucket: "bro-app-ef8ef.appspot.com",
  measurementId: "G-4RK2GXRT0E",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
