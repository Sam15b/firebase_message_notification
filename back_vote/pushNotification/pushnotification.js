var admin = require("firebase-admin");
// var fcm = require('fcm-notification')
var serviceAccount = require("./serviceAccountKey.json");

const FirebaseAdmin = admin.initializeApp({ credential: admin.credential.cert(serviceAccount) })
//var FCM = new fcm(FirebaseAdmin)

const sendPushNotification = async (fcm_token, type, body) => {
  console.log(`Send PUSH NOT${body}`)
  //console.log(serviceAccount)
  console.log(`${type}`)
  try {
    await FirebaseAdmin.messaging().send({
      token: fcm_token,
      notification: {
        title: "Election-Commision",
        body: body,
        //android_channel_id: "push_notification",
        //sound: true
      },
      android: {
        priority: "high",
        notification: {
          channel_id: 'push_notification',
        }
      },
      data: {
        type: String(type),
        body: "data body",
        title: "Data",
        _id: String(1338)
      },
    },)
  } catch (err) {
    throw err;
  }
}
module.exports = sendPushNotification;