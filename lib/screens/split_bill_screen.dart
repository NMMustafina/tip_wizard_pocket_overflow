import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tip_calculator/screens/custom_button.dart';
import 'package:tip_calculator/screens/info_section.dart';
import 'package:tip_calculator/screens/loader_screen.dart';

class SplitBillScreen extends StatefulWidget {
  final int? initialCount;

  const SplitBillScreen({super.key, this.initialCount});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialCount != null) {
      _controller.text = widget.initialCount.toString();
    }
    _controller.addListener(() {
      _validate();
    });
  }

  void _validate() {
    final text = _controller.text;
    final newValue = int.tryParse(text);
    setState(() {
      if (text.isEmpty) {
        isButtonEnabled = widget.initialCount != null;
      } else {
        isButtonEnabled =
            newValue != null && newValue > 0 && newValue != widget.initialCount;
      }
    });
  }

  void _clearInput() {
    _controller.clear();
  }

  Future<void> _handleSave() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pop(context);

    if (_controller.text.isEmpty) {
      Navigator.pop(context, null);
    } else {
      final count = int.tryParse(_controller.text);
      if (count != null && count > 0) {
        Navigator.pop(context, count);
      }
    }
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
          'Split the bill',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Number of people',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter number of people',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: _clearInput,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            const InfoSection(
              infoText:
                  'The amount per person is calculated by dividing the sum of the value of all items on the bill by the amount of tax for all items on the bill. Rounding is done to hundredths to simplify the process.',
            ),
            const Spacer(),
            CustomButton(
              isEnabled: isButtonEnabled,
              text: 'Save amount',
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const LoaderScreen(),
                );
                _handleSave();
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
