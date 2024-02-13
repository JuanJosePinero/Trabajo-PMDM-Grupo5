import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomLineChart extends StatelessWidget {
  final List<FlSpot> moodData;
  final List<FlSpot> emotionData;
  final List<FlSpot> eventData;
  final List<DateTime> monthStartDates;

  const CustomLineChart({
    Key? key,
    required this.moodData,
    required this.emotionData,
    required this.eventData,
    required this.monthStartDates,
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
              int index = value.toInt();
              if (index < monthStartDates.length) {
                return DateFormat.MMM().format(monthStartDates[index]);
              }
              return '';
            },
          ),
          leftTitles: SideTitles(showTitles: true),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: moodData,
            isCurved: false,
            colors: [Colors.red],
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData:
                BarAreaData(show: false, colors: [Colors.red.withOpacity(0.3)]),
          ),
          LineChartBarData(
            spots: emotionData,
            isCurved: false,
            colors: [Colors.yellow],
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
                show: false, colors: [Colors.yellow.withOpacity(0.3)]),
          ),
          LineChartBarData(
            spots: eventData,
            isCurved: false,
            colors: [Colors.green],
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
                show: false, colors: [Colors.green.withOpacity(0.3)]),
          ),
        ],
      ),
    );
  }
}
