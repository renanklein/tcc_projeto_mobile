import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';
import 'package:tcc_projeto_app/utils/utils.dart';

class AgendaRepository {
  final firestore = Firestore.instance;
  String _userId;
  Map<DateTime, dynamic> _events;

  set events(Map<DateTime, dynamic> events) => this._events = events;
  set userId(String uid) => this._userId = uid;

  Future<Map> addEvent(String name, DateTime eventday, List<String> eventDuration) async {
    
    var eventParameters = {
      "userId" : this._userId,
      "name" : name,
      "eventDay" : eventday,
      "eventDuration": eventDuration,
      "events" : this._events
    };

    var inputParameters = Utils.buildNewEvent(eventParameters);

    await Firestore.instance
        .collection("agenda")
        .document(this._userId)
        .collection("events")
        .document(inputParameters["eventsKey"])
        .setData({"events": inputParameters["dayEventsAsList"]})
        .then((resp) => {})
        .catchError((error) => {});

        return inputParameters["newEvent"];
  }

  Future<Map<DateTime, List>> getEvents({String eventStatus}) async {
    var events;
    await Firestore.instance
        .collection("agenda")
        .document(this._userId)
        .collection("events")
        .getDocuments()
        .then((resp) {
      events = Utils.retriveEventsForAgenda(resp.documents);
    });

    return events;
  }

  Future<List<String>> getOccupedDayTimes(String day) async{
    var occupedHours;
    await firestore
      .collection("agenda")
      .document(this._userId)
      .collection("events")
      .document(day)
      .get()
      .then((resp) =>{
        if(resp.data != null && resp.data.containsKey("events")){
           occupedHours = ConvertUtils.getOccupedHours(resp.data["events"])
        }
      });

      return occupedHours;
  }

  Future<void> updateEvent(DateTime eventDay, Map newEvent, String status, [String reason]) async{
    var events = await getEvents();
    var filteredDate = ConvertUtils.removeTime(eventDay);
    var dayEvent = events[filteredDate];
    var listEvents = ConvertUtils.toMapListOfEvents(dayEvent);

    var oldEvent = listEvents.where((event) => event["id"] == newEvent["id"]).toList().first;
    newEvent["status"] = oldEvent["status"];
    
    if(reason != null) {
      newEvent["reason"] = reason;
    }

    listEvents.remove(oldEvent);
    newEvent["status"] = status;
    listEvents.add(newEvent);

    await firestore
      .collection("agenda")
      .document(this._userId)
      .collection("events")
      .document(ConvertUtils.dayFromDateTime(filteredDate))
      .updateData({
       "events" : listEvents 
      });
  }

  Future removeEvent(DateTime eventDay, String eventId, String reason) async{
    var events = await getEvents();

    var filteredDate = ConvertUtils.removeTime(eventDay);
    var dayEvent = events[filteredDate];

    var listEvents = ConvertUtils.toMapListOfEvents(dayEvent);

    var oldEvent = listEvents.where((event) => event["id"] == eventId).toList().first;
    listEvents.remove(oldEvent);

    oldEvent["status"] = "canceled";
    oldEvent["reason"] = reason;

    listEvents.add(oldEvent);

    await firestore
      .collection("agenda")
      .document(this._userId)
      .collection("events")
      .document(ConvertUtils.dayFromDateTime(filteredDate))
      .updateData({
       "events" : listEvents 
      });
  }

}
