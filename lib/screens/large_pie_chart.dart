import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/check_model.dart';

class LargePieChart extends StatelessWidget {
  final List<CheckModel> checks;

  const LargePieChart({super.key, required this.checks});

  double getTotalCheckAmount(CheckModel check) {
    double total = 0;
    for (var position in check.positions) {
      final cost = double.tryParse(position['cost'] ?? '0') ?? 0;
      final quantity = int.tryParse(position['quantity'] ?? '1') ?? 1;
      total += cost * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double totalChecks = 0;
    double totalTax = 0;
    double totalTip = 0;

    for (var check in checks) {
      final checkAmount = getTotalCheckAmount(check);
      totalChecks += checkAmount;

      if (check.tax != null) {
        totalTax += (checkAmount * check.tax! / 100);
      }

      if (check.tipPercentage != null) {
        totalTip += (checkAmount * check.tipPercentage! / 100);
      }
    }

    totalChecks = double.parse(totalChecks.toStringAsFixed(2));
    totalTax = double.parse(totalTax.toStringAsFixed(2));
    totalTip = double.parse(totalTip.toStringAsFixed(2));

    final totalSum = totalChecks + totalTax + totalTip;

    final taxPercent = totalSum != 0 ? (totalTax / totalSum) * 100 : 0.0;
    final tipPercent = totalSum != 0 ? (totalTip / totalSum) * 100 : 0.0;
    final checksPercent = 100.0 - taxPercent - tipPercent;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151A22),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            height: 176,
            width: 176,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFFF9AC50),
                        value: taxPercent,
                        title: '',
                        radius: 30,
                        badgeWidget: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xCCFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${taxPercent.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        badgePositionPercentageOffset: 0.8,
                      ),
                      PieChartSectionData(
                        color: const Color(0xFFF48221),
                        value: tipPercent,
                        title: '',
                        radius: 30,
                        badgeWidget: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xCCFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${tipPercent.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        badgePositionPercentageOffset: 0.8,
                      ),
                      PieChartSectionData(
                        color: const Color(0xFF00AA13),
                        value: checksPercent,
                        title: '',
                        radius: 30,
                        badgeWidget: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xCCFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${checksPercent.toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        badgePositionPercentageOffset: 0.8,
                      ),
                    ],
                    centerSpaceRadius: 60,
                  ),
                ),
                Text(
                  _formatCurrency(totalSum),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Amount of tax',
                  style: TextStyle(color: Color(0xFFF9AC50), fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(totalTax),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Amount of tips',
                  style: TextStyle(color: Color(0xFFF48221), fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(totalTip),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Amount of checks',
                  style: TextStyle(color: Color(0xFF00AA13), fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(totalChecks),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.compactCurrency(
      symbol: '\$',
      decimalDigits: 1,
    );
    return formatter.format(amount);
  }
}
