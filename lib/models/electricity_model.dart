class ElectricityModel {
  double currentPrice;
  List<PricePerHour> prices;
  ElectricityModel(this.currentPrice, this.prices);
  @override
  String toString() {
    String priceList = prices.map((p) => "${p.time}: \$${p.price.toStringAsFixed(2)}").join("\n");
    return "Electricity Model:\n"
        "Current Price: \$${currentPrice.toStringAsFixed(2)}\n"
        "Prices per Hour:\n$priceList";
  }
}

class PricePerHour {
  String time;
  double price;

  PricePerHour(this.time, this.price);
}