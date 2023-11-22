import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/datamodel.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  List<ChartData> dataList = [];
  late Timer timer;
  Random random = Random();
  DateTime currentMinute = DateTime.now();
  int chartnumber = 0;

  @override
  void initState() {
    super.initState();
    generateData();

    startDataGeneration();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startDataGeneration() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();

      if (now.difference(currentMinute) >= const Duration(minutes: 1)) {
        currentMinute = now;
        chartnumber++;
        setState(() {
          generateData();
        });
      }
      setState(() {
        changebar();
      });
    });
  }

  void changebar() {
    dataList[chartnumber].open = random.nextDouble() * 10.0 + 50.0;
    dataList[chartnumber].close =
        dataList[chartnumber].open + (random.nextBool() ? 1.0 : -1.0);
    dataList[chartnumber].high =
        dataList[chartnumber].open + random.nextDouble();
    dataList[chartnumber].low =
        dataList[chartnumber].open - random.nextDouble();
    dataList[chartnumber].linevalue = random.nextDouble() * 10.0 + 40.0;
  }

  void generateData() {
    DateTime now = DateTime.now();

    // if (now.difference(currentMinute) >= const Duration(minutes: 1)) {
    //   currentMinute = now;
    //   chartnumber++;
    //   setState(() {
    //     generateData();
    //   });
    // }

    double open = random.nextDouble() * 10.0 + 50.0;
    double close = open + (random.nextBool() ? 1.0 : -1.0);
    double high = open + random.nextDouble();
    double low = open - random.nextDouble();
    double lineValue = random.nextDouble() * 10.0 + 40.0;

    ChartData data = ChartData(
        x: now,
        open: open,
        high: high,
        low: low,
        close: close,
        linevalue: lineValue);

    dataList.add(data);

    if (dataList.length > 30) {
      dataList.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Chart Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCartesianChart(
          primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
          ),
          primaryXAxis: DateTimeAxis(
            majorGridLines: const MajorGridLines(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
          ),
          series: <ChartSeries>[
            CandleSeries<ChartData, DateTime>(
              // borderWidth: 6,

              dataSource: dataList,
              xValueMapper: (ChartData data, _) => data.x,
              lowValueMapper: (ChartData data, _) => data.low,
              highValueMapper: (ChartData data, _) => data.high,
              openValueMapper: (ChartData data, _) => data.open,
              closeValueMapper: (ChartData data, _) => data.close,
              bearColor: Colors.red,
              bullColor: Colors.green,
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.bottom,
                textStyle: TextStyle(fontSize: 10),
              ),
            ),
            LineSeries<ChartData, DateTime>(
              dataSource: dataList,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.linevalue,
              color: Colors.green,
              // markerSettings: MarkerSettings(isVisible: true),
            )
          ],
          trackballBehavior: TrackballBehavior(
            enable: true,
            activationMode: ActivationMode.singleTap,
            tooltipAlignment: ChartAlignment.center,
            tooltipDisplayMode: TrackballDisplayMode.floatAllPoints,
            tooltipSettings: const InteractiveTooltip(
                format:
                    'O: point.open \nH: point.high\nL: point.low\nC: point.close'),
          ),
        ),
      ),
    );
  }
}
