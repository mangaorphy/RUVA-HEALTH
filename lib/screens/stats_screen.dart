import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruva_health/providers/cycle_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:ruva_health/models/cycle_data.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Cycle Statistics')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Cycle Length Over Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <CartesianSeries>[
                  LineSeries<CycleData, String>(
                    dataSource: cycleProvider.cycles,
                    xValueMapper: (CycleData cycle, _) =>
                        '${cycle.periodStartDate.month}/${cycle.periodStartDate.year}',
                    yValueMapper: (CycleData cycle, _) => cycle.cycleLength,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
