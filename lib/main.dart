import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'BitCoin value exchange'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
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
  List<BPICurrency> currencies = [];

  _MyHomePageState() {
    fetchCurrencyList().then((currencies) {
      return currencies.map((currency) {
        return fetchCurrency(currency['currency']);
      }).toList();
    }).then((futureList) {
      return Future.wait(futureList);
    }).then((curr) {
      print('Updating state');
      setState(() {
        currencies = curr;
      });
    });


  }

  fromJson(Map<String, dynamic> json, currency) {
    print(json);
    var brlCurrency = json['bpi'][currency];
    return BPICurrency(
      currency: brlCurrency['code'],
      value: brlCurrency['rate'],
      description: brlCurrency['description']
    );
  }

  Future<List<dynamic>> fetchCurrencyList() async {
    final response = await http.get("https://api.coindesk.com/v1/bpi/supported-currencies.json");
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    }

    throw new Exception("Error fetching currencies");
  }

  Future<BPICurrency> fetchCurrency(currency) async {
    print('fetching currencies');
    final response = await http.get("https://api.coindesk.com/v1/bpi/currentprice/$currency.json");
    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body), currency);
    }

    throw new Exception("Error fetching currency");
  }
  
  @override
  Widget build(BuildContext context) {
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
                print(currencies);
                var c = currencies[i];
                return new Container(
                    child: ListTile(
                      title: Text(
                        "${c.value} - ${c.currency}",
                        style: const TextStyle(fontSize: 18.0),
                      ),
                      subtitle: Text(
                        c.description,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                    decoration: new BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide()
                        )
                    )
                );
              },
            )
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            tooltip: 'Increment',
            child: Icon(Icons.search),
          ), // This trailing comma makes auto-formatting nicer for build methods.
      );
  }
}
