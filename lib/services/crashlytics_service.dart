import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  FirebaseCrashlytics getInstance() => FirebaseCrashlytics.instance;  
}