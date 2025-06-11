import 'package:flutter/material.dart';

import '../models/check_model.dart';

class CheckCardWidget extends StatelessWidget {
  final CheckModel check;
  final VoidCallback onTap;

  const CheckCardWidget({
    super.key,
    required this.check,
    required this.onTap,
  });

  double calculateTotal() {
    double total = 0;
    for (var position in check.positions) {
      final cost = double.tryParse(position['cost'] ?? '0') ?? 0;
      final quantity = int.tryParse(position['quantity'] ?? '1') ?? 1;
      total += cost * quantity;
    }
    return double.parse(total.toStringAsFixed(2));
  }

  double calculateTaxAmount(double total) {
    if (check.tax != null) {
      return double.parse(((total * check.tax!) / 100).toStringAsFixed(2));
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final total = calculateTotal();
    final taxAmount = calculateTaxAmount(total);
    final tipAmount = check.tipPercentage != null
        ? ((total * check.tipPercentage! / 100).toStringAsFixed(2))
        : null;
    final splitAmount = check.splitCount != null && check.splitCount! > 1
        ? (((total + taxAmount) / check.splitCount!).toStringAsFixed(2))
        : null;

    return GestureDetector(
      onTap: onTap,
      child: IntrinsicHeight(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF151A22),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        check.placeName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (check.tax != null)
                        Text(
                          'Tax amount    ${taxAmount.toStringAsFixed(2)} \$',
                          style: const TextStyle(color: Colors.white54),
                        ),
                      if (tipAmount != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Tip amount    $tipAmount \$',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Check amount    ${total.toStringAsFixed(2)} \$',
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ),
                      if (splitAmount != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Check amount /${check.splitCount}    $splitAmount \$',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF021128),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios,
                      color: Color(0xFF5F61DF), size: 18),
                  onPressed: onTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
