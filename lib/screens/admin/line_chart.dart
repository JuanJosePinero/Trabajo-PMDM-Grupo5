import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomLineChart extends StatelessWidget {
  final List<FlSpot> moodData;
  final List<FlSpot> emotionData;
  final List<FlSpot> eventData;

  const CustomLineChart({
    Key? key,
    required this.moodData,
    required this.emotionData,
    required this.eventData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (value) {
              return DateFormat.MMM().format(DateTime.fromMillisecondsSinceEpoch(value.toInt()));
            },
          ),
          leftTitles: SideTitles(showTitles: true),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: moodData,
            isCurved: true,
            colors: [Colors.red],
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: true, colors: [Colors.red.withOpacity(0.3)]),
          ),
          LineChartBarData(
            spots: emotionData,
            isCurved: true,
            colors: [Colors.yellow],
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: true, colors: [Colors.yellow.withOpacity(0.3)]),
          ),
          LineChartBarData(
            spots: eventData,
            isCurved: true,
            colors: [Colors.green],
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: true, colors: [Colors.green.withOpacity(0.3)]),
          ),
        ],
      ),
    );
  }
}
