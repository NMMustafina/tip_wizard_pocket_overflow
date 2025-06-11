import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPickerDialog extends StatelessWidget {
  final int selectedMonth;
  final List<int> availableMonths;

  const MonthPickerDialog({
    super.key,
    required this.selectedMonth,
    required this.availableMonths,
  });

  @override
  Widget build(BuildContext context) {
    final monthNames = List.generate(12, (index) {
      return DateFormat.MMM().format(DateTime(0, index + 1));
    });

    return Dialog(
      backgroundColor: const Color(0xFF151A22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF393E80), width: 1),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 48, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Month',
                  style: TextStyle(
                      color: Color(0xFF5F61DF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final isAvailable = availableMonths.contains(index + 1);
                    final isSelected = selectedMonth == index + 1;

                    return GestureDetector(
                      onTap: isAvailable
                          ? () {
                              Navigator.pop(context, index + 1);
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF5F61DF)
                              : isAvailable
                                  ? const Color(0xFF021128)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: isAvailable
                                  ? const Color(0xFF5F61DF)
                                  : Colors.transparent),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          monthNames[index],
                          style: TextStyle(
                            color: isAvailable
                                ? Colors.white
                                : const Color(0xFF22252B),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Select the month to view from the available dates',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context, null),
            ),
          ),
        ],
      ),
    );
  }
}
