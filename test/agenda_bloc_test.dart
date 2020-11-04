import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tcc_projeto_app/agenda/blocs/agenda_bloc.dart';
import 'package:tcc_projeto_app/agenda/repositories/agenda_repository.dart';

class MockAgendaRepository extends Mock implements AgendaRepository {}

void main() {
  MockAgendaRepository fakeAgendaRepository;
  AgendaBloc agendaBloc;

  setUp(() {
    fakeAgendaRepository = MockAgendaRepository();
    agendaBloc = AgendaBloc(agendaRepository: fakeAgendaRepository);
  });

  tearDown(() {
    agendaBloc.close();
  });

  test("When bloc initialize, state should be initial", () {
    expect(agendaBloc.initialState, AgendaInitial());
  });

  group("AgendaCreateButtonPressed event", () {
    test(
        "When an event was dispached and no exception was thrown, it should be emit AgendaEventCreateSuccess",
        () {
      var expectedStates = [EventProcessing(), EventProcessingSuccess()];

      when(fakeAgendaRepository.addEvent("", DateTime(2020), "", [""]))
          .thenAnswer((_) => Future.value(null));

      expectLater(agendaBloc, emitsInOrder(expectedStates));

      agendaBloc.add(AgendaCreateButtonPressed(
          eventDay: DateTime(2020),
          eventStart: "",
          eventEnd: "",
          eventName: "",
          eventPhone: ""));
    });
  });

  group("AgendaLoad event", () {
    test(
        "When event is AgendaLoad and no exception was thrown, it should emit AgendaLoadSuccess",
        () {
      var expectedStates = [
        AgendaLoading(),
        AgendaLoadSuccess(eventsLoaded: Map())
      ];

      when(fakeAgendaRepository.getEvents())
          .thenAnswer((_) => Future.value(Map()));

      expectLater(agendaBloc, emitsInOrder(expectedStates))
          .then((_) => verify(fakeAgendaRepository.getEvents()).called(1));

      agendaBloc.add(AgendaLoad());
    });

    test(
        "When event is AgendaLoad and an exception was thrown, it shoulb be AgendaLoadFail",
        () {
      var expectedStates = [AgendaLoading(), AgendaLoadFail()];

      when(fakeAgendaRepository.getEvents()).thenThrow(Exception());

      expectLater(agendaBloc, emitsInOrder(expectedStates))
          .then((_) => verify(fakeAgendaRepository.getEvents()).called(1));

      agendaBloc.add(AgendaLoad());
    });
  });

  group("AgendaEditButtonPressed event", () {
    test(
        "When event is AgendaEditButtonPressed and no exception was thrown, it should emit AgendaEventEditSuccess",
        () {
      var expectedStates = [EventProcessing(), EventProcessingSuccess()];

      when(fakeAgendaRepository.updateEvent(DateTime(2020), Map(), "state"))
          .thenAnswer((_) => Future.value());

      expectLater(agendaBloc, emitsInOrder(expectedStates));

      agendaBloc.add(AgendaEditButtonPressed(
          eventDay: DateTime(2020),
          eventId: "id",
          eventStatus: "status",
          eventName: "name",
          eventStart: "start",
          eventEnd: "end",
          eventPhone: "phone"));
    });
  });

  group("AgendaDeleteButtonPressed event", () {
    test(
        "When event is AgendaDeleteButtonPressed and no exception was thrown, it should emit AgendaEventDeleteSuccess",
        () {
      var expectedStates = [EventProcessing(), EventProcessingSuccess()];

      when(fakeAgendaRepository.removeEvent(DateTime(2020), "id", "reason"))
          .thenAnswer((_) => Future.value(null));

      expectLater(agendaBloc, emitsInOrder(expectedStates));

      agendaBloc.add(AgendaDeleteButtonPressed(
          reason: "", eventDay: DateTime(2020), eventId: ""));
    });
  });

  group("AgendaEventAvailableTimeLoad event", () {
    test(
        "When event is AgendaEventAvailableTimeLoad and no exception was thrown, it should emit AgendaAvailableTimeSuccess",
        () {
      var expectedStates = [
        AgendaAvailableTimeLoading(),
        AgendaAvailableTimeSuccess(<String>["day1"])
      ];

      when(fakeAgendaRepository.getOccupedDayTimes("day"))
          .thenAnswer((_) => Future.value(["day", "day2"]));

      expectLater(agendaBloc, emitsInOrder(expectedStates));

      agendaBloc.add(AgendaEventAvailableTimeLoad(day: DateTime(2020, 05, 20)));
    });
  });

  group("AgendaEventConfirmButtomPressed event", () {
    test(
        "When event is Agenda EventConfirm and no exception was catched, it shoul emit AgendaEventConfirmSuccess",
        () {
      var expectedStates = [EventProcessing(), EventProcessingSuccess()];

      when(fakeAgendaRepository.updateEvent(DateTime(2020), Map(), "status"))
          .thenAnswer((_) => Future.value());

      expectLater(agendaBloc, emitsInOrder(expectedStates));

      agendaBloc.add(AgendaEventConfirmButtomPressed(
          event: Map(), eventDay: DateTime(2020)));
    });
  });
}
