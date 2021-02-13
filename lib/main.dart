import 'package:flutter/material.dart';
import 'package:universal_html/driver.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qiita LGTM',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyLgtmNumberPage(),
    );
  }
}

class MyLgtmNumberPage extends StatefulWidget {
  @override
  _MyLgtmNumberPageState createState() => _MyLgtmNumberPageState();
}

class _MyLgtmNumberPageState extends State<MyLgtmNumberPage> {
  // 最終的にはAPIから取得したユーザーIDを渡せば良さそう
  static const url = 'https://qiita.com/toda-axiaworks';

  String _lgtmNumber = '';

  @override
  void initState() {
    super.initState();

    _getQiitaLgtmNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Qiita LGTM Sample',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: _lgtmNumber.isNotEmpty
            ? _RoundLgtm(
                label: _lgtmNumber,
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.refresh,
          color: Colors.white,
        ),
        onPressed: _getQiitaLgtmNumber,
      ),
    );
  }

  _getQiitaLgtmNumber() async {
    final driver = HtmlDriver();
    await driver.setDocumentFromUri(Uri.parse(url));

    setState(() {
      _lgtmNumber = driver.document
          .querySelector("a:nth-child(2) > p.css-8ocvku.e13sg1fv2")
          .text;
    });
  }
}

// LGTM数を表示するWidget
class _RoundLgtm extends StatelessWidget {
  const _RoundLgtm({
    this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.lightGreen,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'LGTM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
