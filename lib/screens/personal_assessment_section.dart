import 'package:flutter/material.dart';

class PersonalAssessmentSection extends StatefulWidget {
  final Function(String) onAssessmentSelected;

  const PersonalAssessmentSection({
    super.key,
    required this.onAssessmentSelected,
  });

  @override
  State<PersonalAssessmentSection> createState() =>
      _PersonalAssessmentSectionState();
}

class _PersonalAssessmentSectionState extends State<PersonalAssessmentSection> {
  final List<_AssessmentOption> options = [
    _AssessmentOption(icon: Icons.favorite, label: 'Impeccable service'),
    _AssessmentOption(icon: Icons.thumb_up, label: 'Nice place'),
    _AssessmentOption(icon: Icons.star, label: 'Definitely star'),
    _AssessmentOption(icon: Icons.help_outline, label: 'It could be better'),
    _AssessmentOption(icon: null, label: "It's not worth coming back"),
  ];

  String selected = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Personal assessment',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            Spacer(),
            Text('(optional)', style: TextStyle(color: Colors.white54)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected == option.label;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selected = option.label;
                });
                widget.onAssessmentSelected(option.label);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF6C63FF)
                      : const Color(0xFF021128),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (option.icon != null) ...[
                      Icon(option.icon,
                          color: isSelected ? Colors.white : Colors.white70,
                          size: 16),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      option.label,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _AssessmentOption {
  final IconData? icon;
  final String label;

  _AssessmentOption({required this.icon, required this.label});
}
