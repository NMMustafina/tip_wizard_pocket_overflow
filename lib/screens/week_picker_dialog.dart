import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekPickerDialog extends StatelessWidget {
  final List<DateTime> availableWeeks;
  final DateTime selectedWeekStart;
  final Function(DateTime) onWeekSelected;

  const WeekPickerDialog({
    super.key,
    required this.availableWeeks,
    required this.selectedWeekStart,
    required this.onWeekSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF151A22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF393E80), width: 1),
      ),
      child: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 48, bottom: 16, left: 16, right: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Week',
                  style: TextStyle(
                    color: Color(0xFF5F61DF),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableWeeks.map((weekStart) {
                    final weekEnd = weekStart.add(const Duration(days: 6));
                    final label =
                        '${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d').format(weekEnd)}';
                    final isSelected = isSameDay(weekStart, selectedWeekStart);

                    return GestureDetector(
                      onTap: () {
                        onWeekSelected(weekStart);
                        Navigator.pop(context, weekStart);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF6C63FF)
                              : const Color(0xFF021128),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select the week to view',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
