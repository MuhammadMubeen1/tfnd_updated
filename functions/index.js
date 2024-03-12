const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationOnApproval = functions.firestore
  .document('requests/{requestId}')
  .onUpdate(async (change, context) => {
    const newData = change.after.data();
    const previousData = change.before.data();

    // Check if the status changed to 'approve'
    if (newData.status === 'approve' && previousData.status !== 'approve') {
      const userToken = newData.userToken; // Add a field in your 'requests' collection for the user's FCM token

      // Notification payload
      const payload = {
        notification: {
          title: 'Business Request Approved',
          body: 'Your business request has been approved!',
        },
      };

      // Send notification
      await admin.messaging().sendToDevice(userToken, payload);
    }
  });
