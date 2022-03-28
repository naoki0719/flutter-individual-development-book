import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class SubscriptionDemoPage extends StatefulWidget {
  const SubscriptionDemoPage({
    Key? key,
    this.subscribe = false,
  }) : super(key: key);

  static const routeName = '/subscription';

  static void show(
    BuildContext context, {
    bool subscribe = false,
  }) =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubscriptionDemoPage(
            subscribe: subscribe,
          ),
        ),
      );

  final bool subscribe;

  @override
  _SubscriptionDemoPageState createState() => _SubscriptionDemoPageState();
}

class _SubscriptionDemoPageState extends State<SubscriptionDemoPage> {
  late Package selectedPackage;
  int selectedTerm = 1;

  Future<Offering?> initPurchase() async {
    try {
      final currentInfo = await Purchases.getPurchaserInfo();
      if (currentInfo.activeSubscriptions.isNotEmpty) {
        // 初期表示の期間を設定します
        selectedTerm =
            currentInfo.activeSubscriptions.first.contains('month') ? 1 : 0;
      }

      final offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        selectedPackage = offerings.current!.annual!;
        return offerings.current;
      }
    } on PlatformException catch (e) {
      print(e);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('プレミアム'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: FutureBuilder(
        future: initPurchase(),
        builder: (context, AsyncSnapshot<Offering?> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snapshot.hasData == false) {
            return const Center(
              child: Text('データを取得できませんでした。'),
            );
          }

          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.78,
                    child: Column(
                      children: const [
                        _FeatureText(text: '広告の非表示'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _PriceCards(
                    offering: snapshot.data,
                    onChanged: (package) => selectedPackage = package,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: widget.subscribe
                        ? null
                        : () async {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );

                            try {
                              final purchaserInfo =
                                  await Purchases.purchasePackage(
                                      selectedPackage);
                              if (purchaserInfo
                                  .entitlements.all['premium']!.isActive) {
                                // TODO: アプリで使えるように購読状態に変更する処理を書きます
                              }
                            } catch (_) {
                              showOkAlertDialog(
                                context: context,
                                message: '購入をキャンセルしました。',
                              );
                            }
                            Navigator.pop(context);
                          },
                    child: const Text(
                      '購入する',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade400,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 0.94, 36)),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      try {
                        final restoredInfo =
                            await Purchases.restoreTransactions();

                        if (restoredInfo.activeSubscriptions.isNotEmpty) {
                          // TODO: 購入状態を復元に成功したので、アプリで使えるように購読状態にする処理を書きます

                          Navigator.pop(context);
                          return;
                        }
                      } on PlatformException catch (_) {}

                      Navigator.pop(context);
                      showOkAlertDialog(
                        context: context,
                        message: '過去の購入情報が見つかりません。',
                      );
                    },
                    child: const Text(
                      'すでに購入されている場合は、こちらをタップしてください',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 20,
                    children: [
                      TextButton(
                        onPressed: () async {
                          const url = 'https://example.com/terms-of-use';
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebViewScreen(
                                url: url,
                                title: '利用規約',
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: const Text(
                          '利用規約',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          const url = 'https://example.com/privacy-policy';
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebViewScreen(
                                url: url,
                                title: 'プライバシーポリシー',
                              ),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        child: const Text(
                          'プライバシーポリシー',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FeatureText extends StatelessWidget {
  const _FeatureText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
          ),
          const SizedBox(width: 5),
          Flexible(child: Text(text, softWrap: true)),
        ],
      ),
    );
  }
}

typedef PriceCardSelected = void Function(Package package);

class _PriceCards extends StatefulWidget {
  const _PriceCards({
    Key? key,
    this.offering,
    this.onChanged,
  }) : super(key: key);

  final Offering? offering;
  final PriceCardSelected? onChanged;

  @override
  __PriceCardsState createState() => __PriceCardsState();
}

class __PriceCardsState extends State<_PriceCards> {
  late int _selectedPrice;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        _PriceCard(
          title: '年払い',
          price: widget.offering?.annual?.product.priceString ?? '--',
          active: _selectedPrice == 0,
          onPressed: () {
            setState(() {
              _selectedPrice = 0;
            });
            if (widget.onChanged != null) {
              if (widget.offering?.annual != null) {
                widget.onChanged!(widget.offering!.annual!);
              }
            }
          },
        ),
        _PriceCard(
          title: '月払い',
          price: widget.offering?.monthly?.product.priceString ?? '--',
          active: _selectedPrice == 1,
          onPressed: () {
            setState(() {
              _selectedPrice = 1;
            });
            if (widget.onChanged != null) {
              if (widget.offering?.monthly != null) {
                widget.onChanged!(widget.offering!.monthly!);
              }
            }
          },
        ),
      ],
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({
    Key? key,
    required this.title,
    required this.price,
    required this.active,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final String price;
  final bool active;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.46;
    final labelFontSize = MediaQuery.of(context).size.width * 0.040;
    final priceFontSize = MediaQuery.of(context).size.width * 0.065;
    late Color textColor;

    if (Theme.of(context).brightness == Brightness.light) {
      textColor = Colors.black87;
    } else {
      textColor = Colors.white;
    }

    return Stack(
      children: [
        Card(
          color: active ? Colors.red.shade400 : null,
          child: InkWell(
            onTap: () {
              if (onPressed != null) {
                onPressed!();
              }
            },
            child: Container(
              width: width,
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      title,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: labelFontSize,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: priceFontSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (active)
          const Positioned(
            child: Icon(
              Icons.check,
              size: 32,
            ),
            right: 10,
            top: 8,
          ),
      ],
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    Key? key,
    required this.url,
    this.title,
  }) : super(key: key);

  final String url;
  final String? title;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title != null ? Text(widget.title!) : null,
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          controller.loadUrl(widget.url);
        },
      ),
    );
  }
}
