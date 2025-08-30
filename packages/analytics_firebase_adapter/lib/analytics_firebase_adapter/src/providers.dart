import 'package:core_services/core_services/core_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_sink.dart';

final firebaseAppProvider = FutureProvider<FirebaseApp>((_) async {
  return await Firebase.initializeApp();
});

final firebaseAnalyticsProvider =
    FutureProvider<FirebaseAnalytics>((ref) async {
  await ref.watch(firebaseAppProvider.future);
  return FirebaseAnalytics.instance;
});

final analyticsFirebaseProvider = FutureProvider<AnalyticsSink>((ref) async {
  final fa = await ref.watch(firebaseAnalyticsProvider.future);
  return FirebaseAnalyticsSink(fa);
});
