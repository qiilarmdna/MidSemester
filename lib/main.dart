import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Dosen>> fetchDosens(http.Client client) async {
  final response =
      await client.get('https://flutterapp-aqiilah.000webhostapp.com/readDatajson_mid.php');

  // Use the compute function to run parseDosens in a separate isolate.
  return compute(parseDosens, response.body);
}

// A function that converts a response body into a List<Dosen>.
List<Dosen> parseDosens(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Dosen>((json) => Dosen.fromJson(json)).toList();
}

class Dosen {
  final String nidn;
  final String nama_dosen;
  final String jenjang_akademik;
  final String pendidikan_terakhir;
  final String home_base;

  Dosen({this.nidn, this.nama_dosen, this.jenjang_akademik, this.pendidikan_terakhir, this.home_base});

  factory Dosen.fromJson(Map<String, dynamic> json) {
    return Dosen(
      nidn: json['nidn'] as String,
      nama_dosen: json['nama_dosen'] as String,
      jenjang_akademik: json['jenjang_akademik'] as String,
      pendidikan_terakhir: json['pendidikan_terakhir'] as String,
      home_base: json['home_base'] as String,
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Data Dosen';

    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Dosen>>(
        future: fetchDosens(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? DosensList(DosenData: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class DosensList extends StatelessWidget {
  final List<Dosen> DosenData;

  DosensList({Key key, this.DosenData}) : super(key: key);



Widget viewData(var data,int index)
{
return Container(
    width: 200,
    child: Card(
      color: Colors.pink,
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
         Text(data[index].nidn, style: TextStyle(color: Colors.white)),
         Text(data[index].nama_dosen, style: TextStyle(color: Colors.white)),
         Text(data[index].jenjang_akademik, style: TextStyle(color: Colors.white)),
         Text(data[index].pendidikan_terakhir, style: TextStyle(color: Colors.white)),
         Text(data[index].home_base, style: TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: DosenData.length,
      itemBuilder: (context, index) {
        return viewData(DosenData,index);
      },
    );
  }
}