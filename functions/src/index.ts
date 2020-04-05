import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendTopic = functions.firestore
    .document("agenda/{agendaId}/events/{eventsId}")
    .onWrite(async snapshot => {
        const event = snapshot.after.data();
        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: "Ocorreu uma mudança nesta consulta",
                body: `${event}`,
                icon: "../../assets/images/seringa_icone.png",
                click_action: "FLUTTER_NOTIFICATION_CLICK"
            }
        };
        await fcm.sendToTopic("events", payload);
    });

export const sendUser = functions.firestore
    .document("agenda/{agendaId}")
    .onWrite(async snapshot => {
        // agendaId == userId
        const userId = snapshot.after.id;

        const querySnapshot = await db
            .collection("users")
            .doc(userId)
            .collection("tokens")
            .get();

        const tokens = querySnapshot.docs.map(snap => snap.id)

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: "Notificação de consultas",
                body: "Ocorreu uma mudança em sua agenda",
                icon: "../../assets/images/seringa_icone.png",
                click_action: "FLUTTER_NOTIFICATION_CLICK"
            }
        };
        await fcm.sendToDevice(tokens, payload);
    });

