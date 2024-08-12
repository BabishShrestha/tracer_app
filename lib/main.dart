import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracer_app/features/maps/presentation/full_map_view.dart';
import 'package:tracer_app/features/maps/presentation/widgets/map_widget.dart';
import 'package:tracer_app/features/push_noitification/push_notification_service.dart';
import 'package:tracer_app/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotificationService().initialize();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Scaffold(
      body: FullMapView(),
    ));
  }
}
