import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/check_model.dart';

class SmallPieChart extends StatelessWidget {
  final List<CheckModel> checks;

  const SmallPieChart({super.key, required this.checks});

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
    double totalPaid = 0;

    for (var check in checks) {
      final checkAmount = getTotalCheckAmount(check);
      totalChecks += checkAmount;

      double tax = 0;
      double tip = 0;

      if (check.tax != null) {
        tax = (checkAmount * check.tax! / 100);
        totalTax += tax;
      }

      if (check.tipPercentage != null) {
        tip = (checkAmount * check.tipPercentage! / 100);
        totalTip += tip;
      }

      final fullAmount = checkAmount + tax + tip;

      if (check.splitCount != null && check.splitCount! > 1) {
        totalPaid += (fullAmount / check.splitCount!);
      } else {
        totalPaid += fullAmount;
      }
    }

    totalChecks = double.parse(totalChecks.toStringAsFixed(2));
    totalTax = double.parse(totalTax.toStringAsFixed(2));
    totalTip = double.parse(totalTip.toStringAsFixed(2));
    totalPaid = double.parse(totalPaid.toStringAsFixed(2));

    final totalSum = totalChecks + totalTax + totalTip;
    final amountPaidPercent =
        totalSum != 0 ? (totalPaid / totalSum) * 100 : 0.0;
    final remainingPercent = 100.0 - amountPaidPercent;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151A22),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: const Color(0xFF00AA13),
                        value: remainingPercent,
                        title: '',
                        radius: 25,
                        badgeWidget: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xCCFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${remainingPercent.toStringAsFixed(0)}%',
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
                        color: const Color(0xFF5C83C4),
                        value: amountPaidPercent,
                        title: '',
                        radius: 25,
                        badgeWidget: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xCCFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${amountPaidPercent.toStringAsFixed(0)}%',
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
                    centerSpaceRadius: 40,
                  ),
                ),
                Text(
                  _formatCurrency(totalSum),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
                  'Amount paid of the amount of checks',
                  style: TextStyle(color: Color(0xFF5C83C4), fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatCurrency(totalPaid),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
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
