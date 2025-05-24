import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transparent Bar Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChartPage(),
    );
  }
}

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transparent Bars with Red Border'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: TransparentBorderBarChart(),
        ),
      ),
    );
  }
}

class TransparentBorderBarChart extends StatelessWidget {
  const TransparentBorderBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 20,
          barTouchData: BarTouchData(enabled: false),

          // Titles: wrap SideTitles in AxisTitles
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(color: Colors.black, fontSize: 12);
                  final labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                  final idx = value.toInt();
                  return SideTitleWidget(
                    meta: meta,
                    space: 6,
                    child: Text(
                      idx >= 0 && idx < labels.length ? labels[idx] : '',
                      style: style,
                    ),
                  );
                },
              ),
            ),
          ),

          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),

          barGroups: _buildBarGroups(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final values = [8.0, 15.0, 12.0, 18.0, 10.0];
    return List.generate(values.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: values[i],
            color: Colors.transparent, // transparent fill
            borderSide: const BorderSide(
              // red border via borderSide:contentReference[oaicite:0]{index=0}
              color: Colors.red,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
            width: 20,
          ),
        ],
      );
    });
  }
}
