import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance/quotations?key=a0115970";

void main() async {
  runApp(MaterialApp(
    title: "Conversor de Moedas",
    home: Home(),
  ));
}

Future<Map> getInfo() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realControl = TextEditingController();
  final dolarControl = TextEditingController();
  final euroControl = TextEditingController();
  double dolar, euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          "Convert.Me",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: getInfo(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Carregando dados",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Erro ao carregar dados",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ));
                } else {
                  dolar = double.parse(snapshot.data["results"]["currencies"]
                          ["USD"]["buy"]
                      .toString());
                  euro = double.parse(snapshot.data["results"]["currencies"]
                          ["EUR"]["buy"]
                      .toString());
                  return App();
                }
            }
          }),
    );
  }

  void _clearAll(){
    realControl.text = "";
    dolarControl.text = "";
    euroControl.text = "";
  }

  void _changeEuro(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double _euro = double.parse(text)*euro;
    realControl.text = _euro.toStringAsFixed(3);
    dolarControl.text = (_euro/dolar).toStringAsFixed(3);
  }

  void _changeDolar(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double _dolar = double.parse(text)*dolar;
    realControl.text = _dolar.toStringAsFixed(3);
    euroControl.text = (_dolar/euro).toStringAsFixed(3);
  }

  void _changeReal(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double _real = double.parse(text);
    dolarControl.text = (_real/dolar).toStringAsFixed(3);
    euroControl.text = (_real/euro).toStringAsFixed(3);
  }

  Widget App() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Divider(),
          Icon(
            Icons.monetization_on,
            color: Colors.yellow,
            size: 150,
          ),
          Divider(),
          textArea("Real", "R\$", realControl, _changeReal),
          Divider(),
          textArea("Dolar", "USD", dolarControl, _changeDolar),
          Divider(),
          textArea("Euro", "€", euroControl, _changeEuro),
        ],
      ),
    );
  }

  Widget textArea(String label, String prefix, TextEditingController control,
      Function changer) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: TextField(
        controller: control,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
          prefixText: prefix,
          prefixStyle: TextStyle(color: Colors.yellow),
          border: OutlineInputBorder(),
          labelText: label,
          labelStyle: TextStyle(fontSize: 20, color: Colors.yellow),
        ),
        style: TextStyle(color: Colors.yellow),
        onChanged: changer,
      ),
    );
  }
}
