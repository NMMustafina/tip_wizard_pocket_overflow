import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tip_calculator/screens/custom_button.dart';
import 'package:tip_calculator/screens/info_section.dart';
import 'package:tip_calculator/screens/loader_screen.dart';
import 'package:tip_calculator/screens/tax_section.dart';

import '../services/settings_service.dart';

class PermanentTaxAmountScreen extends StatefulWidget {
  const PermanentTaxAmountScreen({super.key});

  @override
  State<PermanentTaxAmountScreen> createState() =>
      _PermanentTaxAmountScreenState();
}

class _PermanentTaxAmountScreenState extends State<PermanentTaxAmountScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isButtonEnabled = false;
  double? savedTax;

  @override
  void initState() {
    super.initState();
    loadSavedTax();
    _controller.addListener(() {
      _validate();
    });
  }

  Future<void> loadSavedTax() async {
    final saved = await SettingsService.getDefaultTaxAmount();
    if (saved != null) {
      _controller.text = saved.toStringAsFixed(2);
      savedTax = saved;
      setState(() {});
    }
  }

  void _validate() {
    final text = _controller.text;
    final newValue = double.tryParse(text);
    setState(() {
      if (text.isEmpty) {
        isButtonEnabled = savedTax != null;
      } else {
        isButtonEnabled =
            newValue != null && newValue >= 0 && newValue != savedTax;
      }
    });
  }

  Future<void> _showExitConfirmation() async {
    final hasChanges = (_controller.text.isNotEmpty &&
            double.tryParse(_controller.text) != savedTax) ||
        (_controller.text.isEmpty && savedTax != null);

    if (!hasChanges) {
      if (mounted) Navigator.pop(context);
      return;
    }

    final shouldLeave = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            'Leave the page',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Your new permanent tax amount will not be saved',
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
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Leave',
                style: TextStyle(color: CupertinoColors.activeBlue),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLeave ?? false) {
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _handleSave() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoaderScreen(),
    );

    final text = _controller.text;
    if (text.isEmpty) {
      await SettingsService.saveDefaultTaxAmount(null);
    } else {
      final tax = double.tryParse(text);
      if (tax != null && tax >= 0) {
        await SettingsService.saveDefaultTaxAmount(tax);
      }
    }

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pop(context);
    Navigator.pop(context);
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
          onPressed: _showExitConfirmation,
        ),
        title: const Text(
          'Permanent tax amount',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaxSection(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: _validate,
            ),
            const SizedBox(height: 24),
            const InfoSection(
              infoText:
                  'The tax is calculated by adding the product of the value of a single item to the tax value in your state',
            ),
            const Spacer(),
            CustomButton(
              isEnabled: isButtonEnabled,
              text: 'Save amount',
              onPressed: _handleSave,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
