import 'dart:io';

import 'package:flutter/material.dart';
import 'package:revenuecat_sample/subscription_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Purchases.setDebugLogsEnabled(true);

  if (Platform.isIOS) {
    await Purchases.setup('APIKEY for iOS');
  } else {
    await Purchases.setup('APIKEY for Android');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('サブスクリプション購入画面'),
          onPressed: () => SubscriptionDemoPage.show(
            context,
            subscribe: false,
          ),
        ),
      ),
    );
  }
}
