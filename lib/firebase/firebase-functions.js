const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { v4: uuidv4 } = require('uuid');

admin.initializeApp();
const db = admin.firestore();

const statusSuccessKey = 'success';
const statusFailureKey = 'failure';

exports.addFriend = functions.https.onCall(async (data, context) => {
    const uid = context.auth.uid || null;
    const friendEmail = data.friendID || null;
    if (uid === null || uid === '' || friendEmail === null || friendEmail === '') {
        return {
            'status': 'failure',
            'message': 'UNAUTHORIZED'
        }
    }
    const friendDetails = await admin.auth().getUserByEmail(friendEmail);
    const friendUID = friendDetails.uid;
    if (friendUID === null || friendUID === '') {
        return {
            'status': 'failure',
            'message': 'UNAUTHORIZED'
        }
    }
    const userDocRef = await db.doc(`Users/${uid}/friends/${friendUID}`).get();
    const friendsDocRef = await db.doc(`Users/${friendUID}/friends/${uid}`).get();
    if ((userDocRef.exists && userDocRef.data()['friendshipStatus'] === 'blocked') || (friendsDocRef.exists && friendsDocRef.data()['friendshipStatus'] === 'blocked')) {
        return {
            'status': 'failure',
            'message': 'UNAUTHORIZED'
        }
    }
    if (userDocRef.exists && userDocRef.data() !== null && userDocRef.data() !== undefined && 'groupId' in userDocRef.data()) {
        return {
            'status': 'success',
            'groupId': userDocRef.data()['groupId']
        }
    }
    const newGroupId = uuidv4();
    await db.collection(`Users/${uid}/friends`).doc(friendUID).set({
        'friendshipStatus': 'friend',
        'groupId': newGroupId
    });
    await db.collection(`Users/${friendUID}/friends`).doc(uid).set({
        'friendshipStatus': 'friend',
        'groupId': newGroupId
    });
    db.doc(`Channels/${newGroupId}`).set({
        createdAt: new Date().toISOString(),
        createdBy: uid,
        id: newGroupId,
        members: [uid, friendUID],
    });
    db.doc(`Groups/${newGroupId}`).set({
        createdAt: new Date().toISOString(),
        createdBy: uid,
        id: newGroupId,
        members: [uid, friendUID],
    });
    return {
        'status': 'success',
        'message': 'SUCCESS'
    }
});

exports.observeMessages = functions.firestore
    .document('Groups/{groupId}/messages/{messageId}')
    .onCreate(async (snapshot, context) => {
        const fromName = snapshot.data().fromName || null;
        const from = snapshot.data().from;
        const payload = {
            notification: {
                title: (fromName !== null && fromName !== undefined && fromName !== 'null') ? fromName : 'New message:',
                body: snapshot.data().message
            },
            data: {
                groupId: context.params.groupId,
                messageId: context.params.messageId,
            }
        };
        const membersRef = await db.doc(`Channels/${context.params.groupId}`).get();
        const members = membersRef.data()['members'];
        const memberNotificationIds = [];
        for (let i = 0; i < members.length; i++) {
            if (members[i] === from) continue;
            // eslint-disable-next-line no-await-in-loop
            const status = await admin.database().ref(`${members[i]}`).once('value');
            if (status.val() !== null && status.val() !== undefined) {
                const onlineStatus = status.val()['status'];
                if (onlineStatus !== null && onlineStatus !== undefined && onlineStatus !== 'online') {
                    memberNotificationIds.push(status.val()['details']['notificationToken']);
                }
            }
        }
        if (memberNotificationIds.length > 0){
            await admin.messaging().sendToDevice(memberNotificationIds, payload, { priority: 'high' });
        }
        db.doc(`Channels/${context.params.groupId}`).update({
            recentMessage: {
                message: snapshot.data().message,
                sentAt: new Date().toISOString(),
                sentBy: snapshot.data().from,
            }
        });
    });