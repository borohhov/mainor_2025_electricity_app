
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:mainor_2025_electricity_app/models/electricity_model.dart';

Future<ElectricityModel> getCurrentPrice() async {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day, now.hour, 0, 0);
  final end = start.add(Duration(hours: 12));

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
      List<PricePerHour> prices = [];
      List<dynamic> pricesMap = (jsonResponse['data']['ee'] as List<dynamic>);
      for(int i = 0; i < pricesMap.length; i++ ) {
        int timestamp = pricesMap[i]['timestamp'];
        String date = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(timestamp*1000));
        prices.add(PricePerHour(date, pricesMap[i]['price']));
      }
      ElectricityModel elModel = ElectricityModel(price, prices);
      return elModel;
    }
  }
  catch (e) {
    throw Exception("Error in fetching the price: $e");
  }
  throw Exception("Unknown error in fetching the price.");
}