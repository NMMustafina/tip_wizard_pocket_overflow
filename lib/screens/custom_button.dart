import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;
  final String text;

  const CustomButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
    this.text = 'Save the check',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          disabledBackgroundColor: const Color(0xFF021128),
          padding: const EdgeInsets.only(top: 4, bottom: 4, right: 4, left: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 0,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: TextStyle(
                  color: isEnabled ? Colors.white : Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isEnabled ? Colors.white : Colors.white70,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward,
                    color: isEnabled
                        ? const Color(0xFF6C63FF)
                        : const Color(0xFF021128),
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
