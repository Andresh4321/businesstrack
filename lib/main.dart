import 'package:businesstrack/app/myapp.dart';
import 'package:businesstrack/core/services/hive/Hive_Service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final hive = HiveService();
  await hive.init();

  runApp(
    ProviderScope(
      overrides: [
        hiveServiceProvider.overrideWithValue(hive),
      ],
      child: const MyApp(),
    ),
  );
}
