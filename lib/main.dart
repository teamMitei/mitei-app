import 'package:flutter/material.dart';
import 'first_view.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'models/Map_app.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert' show json;


@JsonSerializable()

Future<List<Map_app>> fetchMaps() async {
  final response = await http.get(Uri.parse('https://hack-u-mitei.herokuapp.com/maps'));
  List<Map_app> stores = [];
  print(response);
  return stores;
}

void main() => runApp(FirstView());
