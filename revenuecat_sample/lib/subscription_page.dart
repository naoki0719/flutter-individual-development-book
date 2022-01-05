import 'package:flutter/material.dart';

/// 仮実装するサブスクリプション購入画面です
class SubScriptionDemoPage extends StatelessWidget {
  const SubScriptionDemoPage({Key? key}) : super(key: key);

  static Future<T?> show<T>(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SubScriptionDemoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('サブスクリプション購入'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.78,
                child: Column(
                  children: [
                    const BenfitText(text: '広告が非表示になります'),
                    const SizedBox(height: 20),
                    const PriceCards(),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        '購入する',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red.shade400,
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.94, 36)),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        '購入情報を復元する',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            '利用規約',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}

/// 訴求テキストです。
class BenfitText extends StatelessWidget {
  const BenfitText({
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

class PriceCards extends StatefulWidget {
  const PriceCards({
    Key? key,
  }) : super(key: key);

  @override
  _PriceCardsState createState() => _PriceCardsState();
}

class _PriceCardsState extends State<PriceCards> {
  int _selectedPrice = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PriceCard(
          title: '月払い',
          price: '¥250',
          active: _selectedPrice == 0,
          onPressed: () {
            setState(() {
              _selectedPrice = 0;
            });
          },
        ),
        PriceCard(
          title: '年払い',
          price: '¥2,500',
          active: _selectedPrice == 1,
          onPressed: () {
            setState(() {
              _selectedPrice = 1;
            });
          },
        ),
      ],
    );
  }
}

class PriceCard extends StatelessWidget {
  const PriceCard({
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
    final width = MediaQuery.of(context).size.width * 0.36;
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
