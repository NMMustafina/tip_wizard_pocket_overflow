import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../models/check_model.dart';
import '../services/check_service.dart';
import 'add_check_screen.dart';
import 'analytics_section.dart';
import 'check_card_widget.dart';
import 'check_screen.dart';
import 'custom_button.dart';
import 'empty_checks_widget.dart';
import 'filter_buttons.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String selectedTab = 'All';
  DateTime? selectedDate;
  DateTimeRange? selectedWeek;
  int? selectedMonth;

  String _formattedDate() {
    final now = DateTime.now();
    return DateFormat('MMM d, yyyy').format(now);
  }

  String _formatCheckDate(String date) {
    try {
      final parsedDate = DateFormat('MM.dd.yy').parse(date);
      return DateFormat('MMM d, yyyy').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  Map<String, List<CheckModel>> _groupChecksByDate(List<CheckModel> checks) {
    Map<String, List<CheckModel>> grouped = {};
    for (var check in checks) {
      grouped.putIfAbsent(check.date, () => []).add(check);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        title: Text(
          _formattedDate(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable:
            Hive.box<CheckModel>(CheckService.boxName).listenable(),
        builder: (context, Box<CheckModel> box, _) {
          final allChecks = box.values.toList();

          if (box.values.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: EmptyChecksWidget(
                onCheckCreated: () => setState(() {}),
              ),
            );
          }

          return Stack(
            children: [
              Column(
                children: [
                  _buildFilterButtons(allChecks),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildMainContent(allChecks),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 16,
                child: SafeArea(
                  child: CustomButton(
                    isEnabled: true,
                    text: 'Click to create the check!',
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddCheckScreen()),
                      );
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterButtons(List<CheckModel> checks) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: FilterButtons(
        availableDates:
            checks.map((c) => DateFormat('MM.dd.yy').parse(c.date)).toList(),
        onFilterChanged: ({
          required String selectedTab,
          DateTime? selectedDate,
          DateTimeRange? selectedWeek,
          int? selectedMonth,
        }) {
          setState(() {
            this.selectedTab = selectedTab;
            this.selectedDate = selectedDate;
            this.selectedWeek = selectedWeek;
            this.selectedMonth = selectedMonth;
          });
        },
      ),
    );
  }

  Widget _buildMainContent(List<CheckModel> allChecks) {
    final filteredChecks = _filterChecks(allChecks);
    final groupedChecks = _groupChecksByDate(filteredChecks);
    final sortedDates = groupedChecks.keys.toList()
      ..sort((a, b) => DateFormat('MM.dd.yy')
          .parse(b)
          .compareTo(DateFormat('MM.dd.yy').parse(a)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        AnalyticsSection(checks: filteredChecks),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'History of checks added',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ...sortedDates.map((date) {
          final checks = groupedChecks[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8, left: 4),
                child: Text(
                  _formatCheckDate(date),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              ...checks.map((check) => CheckCardWidget(
                    check: check,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckScreen(check: check)),
                      );
                    },
                  )),
            ],
          );
        }),
        const SizedBox(height: 100),
      ],
    );
  }

  List<CheckModel> _filterChecks(List<CheckModel> checks) {
    if (selectedTab == 'Day' && selectedDate != null) {
      return checks
          .where((c) =>
              DateFormat('MM.dd.yy').parse(c.date).year == selectedDate!.year &&
              DateFormat('MM.dd.yy').parse(c.date).month ==
                  selectedDate!.month &&
              DateFormat('MM.dd.yy').parse(c.date).day == selectedDate!.day)
          .toList();
    } else if (selectedTab == 'Week' && selectedWeek != null) {
      return checks.where((c) {
        final date = DateFormat('MM.dd.yy').parse(c.date);
        return date.isAfter(
                selectedWeek!.start.subtract(const Duration(days: 1))) &&
            date.isBefore(selectedWeek!.end.add(const Duration(days: 1)));
      }).toList();
    } else if (selectedTab == 'Month' && selectedMonth != null) {
      return checks.where((c) {
        final date = DateFormat('MM.dd.yy').parse(c.date);
        return date.month == selectedMonth;
      }).toList();
    }
    return checks;
  }
}
