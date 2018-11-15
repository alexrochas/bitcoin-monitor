import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: 'BitCoin value exchange'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class BPICurrency {
  final String description;
  final String currency;
  final String value;

  BPICurrency({this.description, this.currency, this.value});
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<BPICurrency> currencies = [];

  _MyHomePageState() {
    fetchCurrencies()
        .then((list) {
           setState(() {
             currencies = list;
           });
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  fromJson(Map<String, dynamic> json) {
    var brlCurrency = json['bpi']['BRL'];
    return BPICurrency(
      currency: brlCurrency['code'],
      value: brlCurrency['rate'],
      description: brlCurrency['description']
    );
  }

  Future<List<BPICurrency>> fetchCurrencies() async {
    print('fetching currencies');
    final response = await http.get("https://api.coindesk.com/v1/bpi/currentprice/BRL.json");
    if (response.statusCode == 200) {
      return [
          fromJson(json.decode(response.body))
      ];
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
      return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
          ),
          body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: ListView.builder(
              itemCount: currencies.length,
              primary: false,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, i) {
                var c = currencies[i];
                return ListTile(
                  title: Text(
                    "${c.value} - ${c.currency}",
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  subtitle: Text(
                    c.description,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                );
              },
            )
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ), // This trailing comma makes auto-formatting nicer for build methods.
      );
  }
}
