class ElectricityModel {
  double currentPrice;
  List<PricePerHour> prices;
  ElectricityModel(this.currentPrice, this.prices);
}

class PricePerHour {
  String time;
  double price;

  PricePerHour(this.time, this.price);
}