const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

var msgData;

exports.newBinNotification = functions.firestore
    .document('bin_details/{bin_detailsId}')
    .onCreate((snap, context) => {
        msgData = snap.data();
        admin.firestore().collection('devicestokens').get().then((snap) => {
            var tokens = [];
            if (snap.empty) {
                console.log('No Device');
            } else {
                for (var token of snap.docs) {
                    tokens.push(token.data().devtoken);
                }
                var payload = {
                    "notification": {
                        "title": "From " + msgData.name,
                        "body": "status " + msgData.binstatus + "\n" + "Location " + msgData.location,
                        "sound": "default"
                    },
                    "data": {
                        "sendername": msgData.name,
                        "message": msgData.status
                    }
                }
                return admin.messaging().sendToDevice(tokens, payload).then((response) => {
                    console.log('Pushed them all');
                }).catch((err) => {
                    console.log(err);
                });
            }
        });
    });
exports.changeBinNotification = functions.firestore
    .document('bin_details/{binstatus}')
    .onUpdate((snap, context) => {
        msgData = snap.after.data();
        admin.firestore().collection('devicestokens').get().then((snap) => {
            var tokens = [];
            if (snap.empty) {
                console.log('No Device');
            } else {
                for (var token of snap.docs) {
                    tokens.push(token.data().devtoken);
                }
                var payload = {
                    "notification": {
                        "title": "From " + msgData.name,
                        "body": "status " + msgData.binstatus + "\n" + "Location " + msgData.location,
                        "sound": "default"
                    },
                    "data": {
                        "sendername": msgData.name,
                        "message": msgData.status
                    }
                }
                return admin.messaging().sendToDevice(tokens, payload).then((response) => {
                    console.log('Pushed them all');
                }).catch((err) => {
                    console.log(err);
                });
            }
        });
    });    