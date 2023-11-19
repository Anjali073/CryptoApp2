import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
      title: "My App",
      color: Colors.pinkAccent,
      theme:
          ThemeData(primarySwatch: Colors.pink, brightness: Brightness.light),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Crypto App",
            textDirection: TextDirection.ltr,
          ),
          centerTitle: true,
        ),
        body: _myApp(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.add),
        ),
      )));
}

List<Color?> color = [
  Colors.pink[100],
  Colors.pink[300],
];
final Uri url = Uri.parse("https://api.coincap.io/v2/assets");
var map;
List data = [];

class _myApp extends StatefulWidget {
  const _myApp({super.key});

  @override
  State<_myApp> createState() => __myAppState();
}

class __myAppState extends State<_myApp> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<List> getData() async {
    http.Response response = await http.get(url);

    setState(() {
      map = json.decode(response.body);
      data = map['data'];
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _listView(),
    );
  }
}

Widget _listView() {
  return ListView.separated(
    itemBuilder: (context, index) {
      return _tile(index);
    },
    separatorBuilder: (context, index) {
      return SizedBox(
        height: 25,
      );
    },
    itemCount: data.length,
  );
}

Row _buy(String value) {
  double price = double.parse(value);
  if (price >= 0) {
    return Row(
      children: [
        Icon(Icons.thumb_up_alt),
        Text(
          "ChangeIn24Hrs: " + '${price} %',
          style: TextStyle(color: Colors.green),
        )
      ],
    );
  } else {
    return Row(
      children: [
        Icon(Icons.thumb_down_alt),
        Text(
          "ChangeIn24Hrs: " + '${price} %',
          style: TextStyle(color: Colors.redAccent),
        )
      ],
    );
  }
}

Widget _tile(int index) {
  return ListTile(
    leading: CircleAvatar(
      radius: 25,
      backgroundColor: color[index % 2],
      child: Text(
        '${data[index]['name'][0]}',
        style: TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black38),
      ),
    ),
    title: Text(
      '${data[index]['name']}',
      textDirection: TextDirection.ltr,
    ),
    subtitle: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Price ' + data[index]['priceUsd']),
        _buy(data[index]['changePercent24Hr']),
      ],
    ),
    isThreeLine: true,
  );
}
