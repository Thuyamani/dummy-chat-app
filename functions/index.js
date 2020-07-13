const functions = require('firebase-functions');

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });


exports.myfunction = functions.firestore
.document('messages/{message}')
.onCreate((snapshot, context)=>{
    console.log(snapshot.data());
    return;
})