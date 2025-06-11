import 'package:flutter/material.dart';
import 'package:tip_calculator/screens/custom_button.dart';
import 'package:tip_calculator/screens/info_section.dart';
import 'package:tip_calculator/screens/loader_screen.dart';
import 'package:tip_calculator/screens/tax_section.dart';

class TipCalculationScreen extends StatefulWidget {
  final double? initialPercentage;

  const TipCalculationScreen({super.key, this.initialPercentage});

  @override
  State<TipCalculationScreen> createState() => _TipCalculationScreenState();
}

class _TipCalculationScreenState extends State<TipCalculationScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPercentage != null) {
      _controller.text = widget.initialPercentage!.toStringAsFixed(0);
    }
    _controller.addListener(() {
      _validate();
    });
  }

  void _validate() {
    final text = _controller.text;
    final newValue = double.tryParse(text);
    setState(() {
      if (text.isEmpty) {
        isButtonEnabled = widget.initialPercentage != null;
      } else {
        isButtonEnabled = newValue != null &&
            newValue > 0 &&
            newValue != widget.initialPercentage;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tip calculation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaxSection(
              controller: _controller,
              title: 'Percentage of tips',
              onChanged: _validate,
            ),
            const SizedBox(height: 24),
            const InfoSection(
              infoText:
                  'The amount of the tip is calculated by calculating a set percentage of the sum of the value of all items on the bill. Rounding is done to hundredths to simplify the process.',
            ),
            const SizedBox(height: 16),
            const InfoSection(
              infoText:
                  'In the app\'s settings, you can set a constant percentage for tips.',
            ),
            const Spacer(),
            CustomButton(
              isEnabled: isButtonEnabled,
              text: 'Save amount',
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const LoaderScreen(),
                );

                await Future.delayed(const Duration(seconds: 1));

                if (!context.mounted) return;

                Navigator.pop(context);
                if (_controller.text.isEmpty) {
                  Navigator.pop(context, null);
                } else {
                  final percentage = double.tryParse(_controller.text);
                  if (percentage != null && percentage > 0) {
                    Navigator.pop(context, percentage);
                  }
                }
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
