import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  final String infoText;

  const InfoSection({
    super.key,
    required this.infoText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF6C63FF)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              infoText,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
