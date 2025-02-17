
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mainor_2025_electricity_app/models/electricity_model.dart';

Future<ElectricityModel> getCurrentPrice() async {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day, now.hour, 0, 0);
  final end = start.add(Duration(minutes: 1));

  final dateFormat = DateFormat("yyyy-MM-dd'T'HH'%3A'mm'%3A'ss.SSS'Z'");
  final startParam = dateFormat.format(start);
  final endParam = dateFormat.format(end);

  final url = Uri.parse(
      'https://dashboard.elering.ee/api/nps/price?start=$startParam&end=$endParam');

  final response = await http.get(url);
  try {
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final double price = jsonResponse['data']['ee'][0]['price'];
      ElectricityModel elModel = ElectricityModel(price);
      return elModel;
    }
  }
  catch (e) {
    throw Exception("Error in fetching the price: $e");
  }
  throw Exception("Unknown error in fetching the price.");
}