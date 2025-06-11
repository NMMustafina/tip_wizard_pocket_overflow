import 'package:flutter/material.dart';

import '../models/check_model.dart';
import 'large_pie_chart.dart';
import 'small_pie_chart.dart';

class AnalyticsSection extends StatelessWidget {
  final List<CheckModel> checks;

  const AnalyticsSection({
    super.key,
    required this.checks,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Spending analytics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        LargePieChart(checks: checks),
        const SizedBox(height: 24),
        SmallPieChart(checks: checks),
      ],
    );
  }
}
