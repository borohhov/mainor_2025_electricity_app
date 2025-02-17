import 'package:flutter/material.dart';
import 'package:mainor_2025_electricity_app/models/electricity_model.dart';
import 'package:mainor_2025_electricity_app/services/nordpool_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  late Future<ElectricityModel> electricityFuture;

  @override
  void initState() {
    electricityFuture = getCurrentPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPriceWidget;
    Widget refreshIcon;
    return FutureBuilder<ElectricityModel>(
        future: electricityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            currentPriceWidget = Text("Loading...");
            refreshIcon = Icon(Icons.access_time_outlined);
          } else if (!snapshot.hasData) {
            currentPriceWidget = Text("Error");
            refreshIcon = Icon(Icons.refresh);
          } else {
            currentPriceWidget = Text(
              "€${snapshot.data!.currentPrice.toString()} / kW⋅h",
              style: Theme.of(context).textTheme.headlineLarge,
            );
            refreshIcon = Icon(Icons.refresh);
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("Electricity Price"),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    child: refreshIcon,
                    onTap: () {
                      setState(() {
                        electricityFuture = getCurrentPrice();
                      });
                    },
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                      child: Column(
                    children: [
                      Text(
                        "Current Price ⚡",
                        style: TextStyle(fontSize: 18),
                      ),
                      currentPriceWidget
                    ],
                  )),
                ),
                Column(
                    children: snapshot.data!.prices
                        .map((pricePerHour) => Row(
                              children: [Text(pricePerHour.time), Text(pricePerHour.price.toString())],
                            ))
                        .toList())
              ],
            ),
          );
        });
  }
}
