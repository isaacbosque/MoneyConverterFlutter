import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance/quotations?key=a0115970";

void main() async {
  runApp(MaterialApp(
    title: "Conversor de Moedas",
    home: Home(),
    theme: ThemeData(hintColor: Colors.yellow, primaryColor: Colors.white),
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
                  return App(Dolar,Euro,Real);
                }
            }
          }),
    );
  }

  Widget App(Double dolar) {
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
          textArea("Real", "R\$"),
          Divider(),
          textArea("Dolar", "USD"),
          Divider(),
          textArea("Euro", "€"),
        ],
      ),
    );
  }

  Widget textArea(String label, String prefix) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: TextField(
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
      ),
    );
  }
}
