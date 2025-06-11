import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/check_model.dart';
import '../services/check_service.dart';
import 'full_screen_image_viewer.dart';
import 'split_bill_screen.dart';
import 'tip_calculation_screen.dart';

class CheckScreen extends StatefulWidget {
  final CheckModel check;

  const CheckScreen({super.key, required this.check});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  final CheckService _checkService = CheckService();
  double? tipPercentage;
  int? splitCount;

  @override
  void initState() {
    super.initState();
    tipPercentage = widget.check.tipPercentage;
    splitCount = widget.check.splitCount;
  }

  double calculateTotal() {
    double total = 0;
    for (var position in widget.check.positions) {
      final cost = double.tryParse(position['cost'] ?? '0') ?? 0;
      final quantity = int.tryParse(position['quantity'] ?? '1') ?? 1;
      total += cost * quantity;
    }
    return double.parse(total.toStringAsFixed(2));
  }

  double calculateTaxAmount(double total) {
    if (widget.check.tax != null) {
      return double.parse(
          ((total * widget.check.tax!) / 100).toStringAsFixed(2));
    }
    return 0;
  }

  IconData? getIcon(String label) {
    switch (label) {
      case 'Impeccable service':
        return Icons.favorite;
      case 'Nice place':
        return Icons.thumb_up;
      case 'Definitely star':
        return Icons.star;
      case 'It could be better':
        return Icons.help_outline;
      case "It's not worth coming back":
        return null;
      default:
        return null;
    }
  }

  void showDeleteConfirmation(BuildContext context) {
    showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            'Delete product',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete the check? It will not be possible to undo this action',
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                await deleteCheck(context);
                Navigator.pop(context, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: CupertinoColors.destructiveRed),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCheck(BuildContext context) async {
    final box = Hive.box<CheckModel>(CheckService.boxName);
    final index = box.values.toList().indexOf(widget.check);
    if (index != -1) {
      await _checkService.deleteCheck(index);
    }
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = calculateTotal();
    final taxAmount = calculateTaxAmount(total);
    final assessmentIcon = getIcon(widget.check.personalAssessment ?? '');

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Check ${widget.check.date}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              showDeleteConfirmation(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.check.personalAssessment != null &&
                widget.check.personalAssessment!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (assessmentIcon != null)
                      Icon(assessmentIcon, color: Colors.red, size: 20),
                    if (assessmentIcon != null) const SizedBox(width: 8),
                    Text(
                      widget.check.personalAssessment!,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF151A22),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.check.placeName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.check.placeAddress != null &&
                      widget.check.placeAddress!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        widget.check.placeAddress!,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const Divider(color: Colors.white30, height: 24),
                  const SizedBox(height: 16),
                  Column(
                    children:
                        widget.check.positions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final position = entry.value;
                      final name = position['name'] ?? '';
                      final cost =
                          double.tryParse(position['cost'] ?? '0') ?? 0;
                      final quantity =
                          int.tryParse(position['quantity'] ?? '1') ?? 1;
                      final positionTax = widget.check.tax != null
                          ? ((cost * quantity * widget.check.tax!) / 100)
                              .toStringAsFixed(2)
                          : null;

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '× $quantity',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '${(cost).toStringAsFixed(2)} \$',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          if (positionTax != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '($positionTax \$)',
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          if (index != widget.check.positions.length - 1)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: List.generate(
                                  40,
                                  (index) => const Expanded(
                                    child: Text(
                                      '- ',
                                      style: TextStyle(
                                          color: Colors.white30, fontSize: 12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF151A22),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tax amount',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                        Text(
                          '${calculateTaxAmount(total)} \$',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (tipPercentage != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tip amount ${tipPercentage!.toStringAsFixed(0)}%',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            '${(total * tipPercentage! / 100).toStringAsFixed(2)} \$',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Check amount',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                        Text(
                          '$total \$',
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 16),
                        ),
                      ],
                    ),
                    if (splitCount != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Check amount / $splitCount',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            '${((total + taxAmount) / splitCount!).toStringAsFixed(2)} \$',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (widget.check.imagesPaths.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1,
                  children:
                      widget.check.imagesPaths.asMap().entries.map((entry) {
                    final index = entry.key;
                    final imagePath = entry.value;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullScreenImageViewer(
                              imagePaths: widget.check.imagesPaths,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push<double?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TipCalculationScreen(initialPercentage: tipPercentage),
                  ),
                );
                if (!mounted) return;
                setState(() {
                  tipPercentage = result;
                  widget.check.tipPercentage = result;
                });
                widget.check.save();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0x1A6C63FF),
                side: const BorderSide(color: Color(0xFF6C63FF)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                elevation: 0,
              ),
              child: Center(
                child: Text(
                  tipPercentage == null
                      ? 'Calculate the tip'
                      : 'Change the tip percentage',
                  style: const TextStyle(color: Color(0xFF5F61DF)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push<int?>(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SplitBillScreen(initialCount: splitCount),
                  ),
                );
                if (!mounted) return;
                setState(() {
                  splitCount = result;
                  widget.check.splitCount = result;
                });
                widget.check.save();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                elevation: 0,
              ),
              child: Center(
                child: Text(
                  splitCount == null
                      ? 'Split the bill per company'
                      : 'Change the number of people',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
