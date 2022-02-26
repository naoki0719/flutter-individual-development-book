import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.appTrackingTransparency.request().isGranted;
  await MobileAds.instance.initialize();

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner'),
      ),
      body: const Center(
        child: Text('AdMob Example'),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6.0,
        shape: const AutomaticNotchedShape(
          RoundedRectangleBorder(),
          StadiumBorder(
            side: BorderSide(),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 広告表示
            FutureBuilder(
              future: standardBanner.load(),
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.connectionState == ConnectionState.done,
                  child: SafeArea(
                    child: SizedBox(
                      child: AdWidget(ad: standardBanner),
                      width: double.infinity,
                      height: 50,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 通常のバナーです
final standardBanner = BannerAd(
  size: AdSize.banner,
  adUnitId: Platform.isIOS
      ? 'ca-app-pub-3940256099942544/2934735716'
      : 'ca-app-pub-3940256099942544/6300978111',
  listener: const BannerAdListener(),
  request: const AdRequest(),
);
