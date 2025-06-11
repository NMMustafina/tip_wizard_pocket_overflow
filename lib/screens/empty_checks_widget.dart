import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'add_check_screen.dart';
import 'custom_button.dart';

class EmptyChecksWidget extends StatelessWidget {
  final VoidCallback onCheckCreated;

  const EmptyChecksWidget({super.key, required this.onCheckCreated});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/images/icon_receipt_discount.svg',
              width: 274,
              height: 274,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Color(0xFF6C63FF), size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You haven\'t created a single check. When you create your first check, it will appear on this page under the analytics block of your expenses.',
                  style: TextStyle(color: Colors.white, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        CustomButton(
          isEnabled: true,
          text: 'Click to create your first check!',
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddCheckScreen()),
            );
            onCheckCreated();
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
