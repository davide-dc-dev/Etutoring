import 'dart:async';
import 'dart:convert';

import 'package:argon_flutter/config/config.dart';
import 'package:argon_flutter/widgets/drawer.dart';
import 'package:argon_flutter/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Mycourse extends StatefulWidget {
  @override
  MycourseState createState() => new MycourseState();
}

class MycourseState extends State<Mycourse> {
  List data;

  Future<String> getData() async {
    var response =
        await http.get(Uri.http(authority, unencodedPath + "course_list.php"));

    this.setState(() {
      data = jsonDecode(response.body);
    });

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            title: const Text('Course'),
            backgroundColor: Color.fromRGBO(213, 21, 36, 1)),
        drawer: ArgonDrawer("course"),
        body: new Padding(
            padding: const EdgeInsets.only(
                top: 32, left: 24.0, right: 24.0, bottom: 32),
            child: (ListView.builder(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  child: new Text(data[index]["course_name"] +
                      '\ncfu = ' +
                      data[index]["course_cfu"] +
                      '\ndepartiment = ' +
                      data[index]["department"]),
                );
              },
            ))));
  }
}
