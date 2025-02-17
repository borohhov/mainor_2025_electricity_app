import 'package:flutter/material.dart';
import 'package:mainor_2025_electricity_app/models/electricity_model.dart';
import 'package:mainor_2025_electricity_app/services/nordpool_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Electricity Price"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Center(
          child: FutureBuilder<ElectricityModel>(
              future: getCurrentPrice(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading...");
                }
                if(!snapshot.hasData) {
                  return Text("Error");
                }
                return Column(
                  children: [
                    Text(
                      "Current Price ⚡",
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      "€${snapshot.data!.currentPrice.toString()} / kW⋅h",
                      style: Theme.of(context).textTheme.headlineLarge,
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
