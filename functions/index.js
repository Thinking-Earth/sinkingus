const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const firestore = admin.firestore();

exports.getTime = functions.region("asia-northeast3").https.onCall((data, context) => {
    let date = new Date().getTime();
    return date;
});
