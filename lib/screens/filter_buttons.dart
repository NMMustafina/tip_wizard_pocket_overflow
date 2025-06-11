import 'package:flutter/material.dart';

import 'calendar_popup.dart';
import 'month_picker_dialog.dart';
import 'week_picker_dialog.dart';

class FilterButtons extends StatefulWidget {
  final Function({
    required String selectedTab,
    DateTime? selectedDate,
    DateTimeRange? selectedWeek,
    int? selectedMonth,
  }) onFilterChanged;
  final List<DateTime> availableDates;

  const FilterButtons({
    super.key,
    required this.availableDates,
    required this.onFilterChanged,
  });

  @override
  State<FilterButtons> createState() => _FilterButtonsState();
}

class _FilterButtonsState extends State<FilterButtons> {
  String selectedTab = 'All';
  DateTime? selectedDate;
  DateTimeRange? selectedWeek;
  int? selectedMonth;

  void _selectDay() {
    showDialog<DateTime>(
      context: context,
      builder: (_) => CalendarPopup(
        focusedDay: DateTime.now(),
        selectedDay: DateTime.now(),
        availableDates: widget.availableDates,
        onDateSelected: (day) {
          setState(() {
            selectedTab = 'Day';
            selectedDate = day;
          });
          widget.onFilterChanged(
            selectedTab: selectedTab,
            selectedDate: selectedDate,
            selectedWeek: null,
            selectedMonth: null,
          );
        },
      ),
    );
  }

  void _selectWeek() async {
    final weeks = _getAvailableWeeks();
    final selected = await showDialog<DateTime>(
      context: context,
      builder: (_) => WeekPickerDialog(
        availableWeeks: weeks,
        selectedWeekStart: weeks.isNotEmpty ? weeks.first : DateTime.now(),
        onWeekSelected: (_) {},
      ),
    );
    if (!mounted) return;
    if (selected != null) {
      setState(() {
        selectedTab = 'Week';
        selectedWeek = DateTimeRange(
            start: selected, end: selected.add(const Duration(days: 6)));
        selectedDate = null;
        selectedMonth = null;
      });
      widget.onFilterChanged(
        selectedTab: selectedTab,
        selectedDate: null,
        selectedWeek: selectedWeek,
        selectedMonth: null,
      );
    }
  }

  void _selectMonth() async {
    final months = _getAvailableMonths();
    final selected = await showDialog<int>(
      context: context,
      builder: (_) => MonthPickerDialog(
        selectedMonth: selectedMonth ?? DateTime.now().month,
        availableMonths: months,
      ),
    );
    if (!mounted) return;
    if (selected != null) {
      setState(() {
        selectedTab = 'Month';
        selectedMonth = selected;
        selectedDate = null;
        selectedWeek = null;
      });
      widget.onFilterChanged(
        selectedTab: selectedTab,
        selectedDate: null,
        selectedWeek: null,
        selectedMonth: selectedMonth,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: ['All', 'Day', 'Week', 'Month'].map((label) {
            final isActive = selectedTab == label;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      if (label == 'All') {
                        setState(() {
                          selectedTab = 'All';
                          selectedDate = null;
                          selectedWeek = null;
                          selectedMonth = null;
                        });
                        widget.onFilterChanged(
                          selectedTab: selectedTab,
                          selectedDate: null,
                          selectedWeek: null,
                          selectedMonth: null,
                        );
                      } else if (label == 'Day') {
                        _selectDay();
                      } else if (label == 'Week') {
                        _selectWeek();
                      } else if (label == 'Month') {
                        _selectMonth();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActive
                          ? const Color(0xFF6C63FF)
                          : const Color(0xFF021128),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<DateTime> _getAvailableWeeks() {
    final weeks = <DateTime>{};
    for (var date in widget.availableDates) {
      final weekStart = date.subtract(Duration(days: date.weekday - 1));
      weeks.add(DateTime(weekStart.year, weekStart.month, weekStart.day));
    }
    return weeks.toList();
  }

  List<int> _getAvailableMonths() {
    final months = widget.availableDates.map((d) => d.month).toSet().toList();
    months.sort();
    return months;
  }
}
