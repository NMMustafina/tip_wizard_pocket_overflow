import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPopup extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final List<DateTime> availableDates;
  final Function(DateTime) onDateSelected;

  const CalendarPopup({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.availableDates,
    required this.onDateSelected,
  });

  bool _isAvailable(DateTime day) {
    return availableDates.any(
        (d) => d.year == day.year && d.month == day.month && d.day == day.day);
  }

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
            padding: const EdgeInsets.only(top: 48, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) =>
                      !isSameDay(day, DateTime.now()) &&
                      isSameDay(day, selectedDay),
                  onDaySelected: (selected, focused) {
                    onDateSelected(selected);
                    Navigator.pop(context);
                  },
                  enabledDayPredicate: (day) => _isAvailable(day),
                  headerStyle: const HeaderStyle(
                    titleTextStyle: TextStyle(
                        color: Color(0xFF5F61DF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon:
                        Icon(Icons.chevron_left, color: Color(0xFF5F61DF)),
                    rightChevronIcon:
                        Icon(Icons.chevron_right, color: Color(0xFF5F61DF)),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.white),
                    weekendStyle: TextStyle(color: Colors.white),
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Color(0xFF5F61DF),
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(color: Colors.white),
                    selectedDecoration: BoxDecoration(
                      color: Color(0xFF6C63FF),
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(color: Colors.white),
                    defaultTextStyle: TextStyle(color: Colors.white),
                    weekendTextStyle: TextStyle(color: Colors.white),
                    outsideTextStyle: TextStyle(color: Color(0xFF22252B)),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      if (_isAvailable(day)) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF021128),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Select the date to view from the available dates',
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
}
