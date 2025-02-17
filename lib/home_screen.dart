import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String formatTime(String dateTime) {
    DateTime parsedTime = DateTime.parse(dateTime);
    return DateFormat.Hm().format(parsedTime); // Formats as HH:mm
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
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
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
            snapshot.hasData ? Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(), // Prevent scrolling
                child: SizedBox(
                  width: MediaQuery.of(context).size.width, // Stretch table
                  child: DataTable(
                    columnSpacing: 30, // Adjust spacing between columns
                    dataRowMinHeight: 25, // Reduce row height
                    dataRowMaxHeight: 30,
                    headingRowHeight: 40, // Reduce header height
                    columns: [
                      DataColumn(
                        label: Text("Time", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Container(
                          alignment: Alignment.centerRight, // Align column header properly
                          width: 80, // Ensure alignment matches data cells
                          child: Text("Price (€)", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                    rows: snapshot.data!.prices.map((pricePerHour) {
                      return DataRow(cells: [
                        DataCell(Text(formatTime(pricePerHour.time), style: TextStyle(fontSize: 14))),
                        DataCell(
                          Container(
                            alignment: Alignment.centerRight, // Ensure right alignment
                            width: 80, // Match header width
                            child: Text("${pricePerHour.price.toStringAsFixed(2)} €", style: TextStyle(fontSize: 14)),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            )

                : Center(child: Text("No data available"))
                ],
              ),
            ),
          );
        });
  }
}
