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
                    child:
                    Text(
                      "Carregando dados",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                );
              default:
                if(snapshot.hasError){
                  return Center(
                      child:
                      Text(
                        "Erro ao carregar dados",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                  );
                }else{
                  return Container(
                    child:
                    Center(
                        child:
                        Text(
                          "Dados Carregados",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                    ),
                  );
                }

            }
          }),
    );
  }
}
