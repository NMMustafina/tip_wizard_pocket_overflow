import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tip_calculator/screens/custom_button.dart';
import 'package:tip_calculator/screens/info_section.dart';
import 'package:tip_calculator/screens/loader_screen.dart';
import 'package:tip_calculator/screens/tax_section.dart';

import '../services/settings_service.dart';

class PermanentTipAmountScreen extends StatefulWidget {
  const PermanentTipAmountScreen({super.key});

  @override
  State<PermanentTipAmountScreen> createState() =>
      _PermanentTipAmountScreenState();
}

class _PermanentTipAmountScreenState extends State<PermanentTipAmountScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isButtonEnabled = false;
  int? savedPercentage;

  @override
  void initState() {
    super.initState();
    loadSavedPercentage();
    _controller.addListener(() {
      _validate();
    });
  }

  Future<void> loadSavedPercentage() async {
    final saved = await SettingsService.getDefaultTipPercentage();
    if (saved != null) {
      _controller.text = saved.toInt().toString();
      savedPercentage = saved.toInt();
      setState(() {});
    }
  }

  void _validate() {
    final text = _controller.text;
    final newValue = int.tryParse(text);
    setState(() {
      if (text.isEmpty) {
        isButtonEnabled = savedPercentage != null;
      } else {
        isButtonEnabled =
            newValue != null && newValue > 0 && newValue != savedPercentage;
      }
    });
  }

  Future<void> _showExitConfirmation() async {
    final hasChanges = (_controller.text.isNotEmpty &&
            int.tryParse(_controller.text) != savedPercentage) ||
        (_controller.text.isEmpty && savedPercentage != null);

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
            'Your new permanent tip amount will not be saved.',
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
      await SettingsService.saveDefaultTipPercentage(null);
    } else {
      final percentage = int.tryParse(text);
      if (percentage != null && percentage > 0) {
        await SettingsService.saveDefaultTipPercentage(percentage.toDouble());
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
          'Permanent tip amount',
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
              keyboardType: TextInputType.number,
              onChanged: _validate,
            ),
            const SizedBox(height: 24),
            const InfoSection(
              infoText:
                  'Tipping is calculated by finding the percentage of the set value of the total value of the check items excluding tax.',
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
