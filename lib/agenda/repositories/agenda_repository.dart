import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';
import 'package:tcc_projeto_app/utils/utils.dart';

class AgendaRepository {
  final firestore = FirebaseFirestore.instance;
  String _userId;
  Map<DateTime, dynamic> _events;

  set events(Map<DateTime, dynamic> events) => this._events = events;
  set userId(String uid) => this._userId = uid;

  Future<Map> addEvent(
      String name, DateTime eventday, List<String> eventDuration) async {
    var eventParameters = {
      "userId": this._userId,
      "name": name,
      "eventDay": eventday,
      "eventDuration": eventDuration,
      "events": this._events
    };

    var inputParameters = Utils.buildNewEvent(eventParameters);

    await firestore
        .collection("agenda")
        .doc(this._userId)
        .collection("events")
        .doc(inputParameters["eventsKey"])
        .set({"events": inputParameters["dayEventsAsList"]})
        .then((resp) => {})
        .catchError((error) => {});

    return inputParameters["newEvent"];
  }

  Future<Map<DateTime, List>> getEvents({String eventStatus}) async {
    var events;
    await FirebaseFirestore.instance
        .collection("agenda")
        .doc(this._userId)
        .collection("events")
        .get()
        .then((resp) {
      events = Utils.retriveEventsForAgenda(resp.docs);
    });

    return events;
  }

  Future<List<String>> getOccupedDayTimes(String day) async {
    var occupedHours;
    await firestore
        .collection("agenda")
        .doc(this._userId)
        .collection("events")
        .doc(day)
        .get()
        .then((resp) => {
              if (resp.data != null && resp.data().containsKey("events"))
                {
                  occupedHours =
                      ConvertUtils.getOccupedHours(resp.data()["events"])
                }
            });

    return occupedHours;
  }

  Future<void> updateEvent(DateTime eventDay, Map newEvent, String status,
      [String reason]) async {
    var events = await getEvents();

    var eventParameters = {
      "events": events,
      "eventDay": eventDay,
      "newEvent": newEvent,
      "status": status,
      "reason": reason
    };

    var inputParameters = Utils.buildUpdateEvent(eventParameters);

    await firestore
        .collection("agenda")
        .doc(this._userId)
        .collection("events")
        .doc(ConvertUtils.dayFromDateTime(inputParameters["filteredDate"]))
        .update({"events": inputParameters["events"]});
  }

  Future removeEvent(DateTime eventDay, String eventId, String reason) async {
    var events = await getEvents();

    var filteredDate = ConvertUtils.removeTime(eventDay);
    var dayEvent = events[filteredDate];

    var listEvents = ConvertUtils.toMapListOfEvents(dayEvent);

    var oldEvent =
        listEvents.where((event) => event["id"] == eventId).toList().first;
    listEvents.remove(oldEvent);

    oldEvent["status"] = "canceled";
    oldEvent["reason"] = reason;

    listEvents.add(oldEvent);

    await firestore
        .collection("agenda")
        .doc(this._userId)
        .collection("events")
        .doc(ConvertUtils.dayFromDateTime(filteredDate))
        .update({"events": listEvents});
  }
}
