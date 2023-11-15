class ChartData {
  ChartData(
      {required this.x,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      required this.linevalue});

  final DateTime x;
  double open;
  double high;
  double low;
  double close;
  double linevalue;
}
