const { onValueUpdated } = require("firebase-functions/v2/database");
const admin = require("firebase-admin");
admin.initializeApp();

exports.checkAlarmAndSendNotification = onValueUpdated(
    {
        ref: "/AlarmSystem/door1State",
        instance: "smarthomealarm-2a78d-default-rtdb",
        region: "europe-west1" // <--- This moves the function to Europe!
    },
    async (event) => {
        const beforeState = event.data.before.val();
        const afterState = event.data.after.val();

        // Only trigger if the door specifically changes from CLOSED to OPEN
        if (beforeState === "CLOSED" && afterState === "OPEN") {

            const db = admin.database();

            // Check if notifications are enabled
            const settingsSnap = await db.ref("/AlarmSystem/notificationsEnabled").once("value");
            if (settingsSnap.val() !== true) {
                return console.log("Notifications are disabled. Aborting.");
            }

            // Grab the phone's FCM token
            const tokenSnap = await db.ref("/AlarmSystem/fcmToken").once("value");
            const token = tokenSnap.val();

            if (!token) {
                return console.log("No FCM token found.");
            }

            // Build the notification payload
            const payload = {
                token: token,
                notification: {
                    title: "🚨 ALARM TRIGGERED!",
                    body: "Door 1 has been opened."
                },
                android: {
                    priority: "high",
                    notification: {
                        sound: "default"
                    }
                }
            };

            // Send the notification!
            try {
                await admin.messaging().send(payload);
                console.log("Notification sent successfully!");
            } catch (error) {
                console.error("Error sending notification:", error);
            }
        }
    });