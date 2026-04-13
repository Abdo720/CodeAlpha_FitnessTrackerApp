import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/core/resources/consetants/conests.dart';
import 'package:fitness/core/resources/firebase/constantfounctions.dart';
import 'package:fitness/features/AddTab/data/ExModel/ExModel.dart';
import 'package:flutter/material.dart';

// ─── Models ───────────────────────────────────────────────────────────────────

class CategoryChartData {
  final String category;
  final double totalTime;
  final double totalCal;

  const CategoryChartData({
    required this.category,
    required this.totalTime,
    required this.totalCal,
  });
}

class DayChartData {
  final DateTime date;
  final double totalTime;
  final double totalCal;

  const DayChartData({
    required this.date,
    required this.totalTime,
    required this.totalCal,
  });

  String get dayLabel {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return labels[date.weekday - 1];
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

class ChartProvider extends ChangeNotifier {
  List<CategoryChartData> dayChartData = [];
  bool isLoadingDay = true;

  List<DayChartData> weekChartData = [];
  bool isLoadingWeek = true;

  final Map<String, double> _timeAcc = {};
  final Map<String, double> _calAcc = {};

  final List<StreamSubscription> _daySubs = [];
  StreamSubscription? _weekSub;

  void init() {
    _listenDayChart();
    _listenWeekChart();
  }

  // ─── Day chart ────────────────────────────────────────────────────────────
  // Single stream for all today's done exercises → group by category in Dart
  // This avoids needing a Firestore composite index

  void _listenDayChart() {
    for (final sub in _daySubs) sub.cancel();
    _daySubs.clear();

    for (final c in Conests.activityCategories) {
      _timeAcc[c] = 0;
      _calAcc[c] = 0;
    }

    final now = DateTime.now();
    final startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    ).millisecondsSinceEpoch;
    final endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(const Duration(days: 1)).millisecondsSinceEpoch;

    // Uses getExsToChartOfDayStream but without the category filter —
    // we call the base collection directly via getExsIsDoneStream variant
    final sub = FireBaseConestFounctions.getExCollection()
        .where("date", isGreaterThanOrEqualTo: startOfDay)
        .where("date", isLessThan: endOfDay)
        .where("isDone", isEqualTo: true)
        .snapshots()
        .listen(
          (QuerySnapshot<ExModel> snapshot) {
            for (final c in Conests.activityCategories) {
              _timeAcc[c] = 0;
              _calAcc[c] = 0;
            }

            for (final doc in snapshot.docs) {
              final ExModel m = doc.data();
              final double time = double.tryParse(m.time.trim()) ?? 0;
              final double cal = double.tryParse(m.cal.trim()) ?? 0;

              if (_timeAcc.containsKey(m.category)) {
                _timeAcc[m.category] = _timeAcc[m.category]! + time;
                _calAcc[m.category] = _calAcc[m.category]! + cal;
              }
            }
            _rebuildDayChart();
          },
          onError: (e) {
            debugPrint("Day chart error: $e");
            isLoadingDay = false;
            notifyListeners();
          },
        );

    _daySubs.add(sub);
  }

  void _rebuildDayChart() {
    dayChartData = Conests.activityCategories
        .map(
          (c) => CategoryChartData(
            category: c,
            totalTime: _timeAcc[c] ?? 0,
            totalCal: _calAcc[c] ?? 0,
          ),
        )
        .toList();
    isLoadingDay = false;
    notifyListeners();
  }

  // ─── Week chart ───────────────────────────────────────────────────────────

  void _listenWeekChart() {
    _weekSub?.cancel();

    _weekSub = FireBaseConestFounctions.getExsToChartOfWeekStream().listen(
      (QuerySnapshot<ExModel> snapshot) {
        final Map<String, _DayAcc> byDay = {};

        for (final doc in snapshot.docs) {
          final ExModel m = doc.data();
          final double time = double.tryParse(m.time.trim()) ?? 0;
          final double cal = double.tryParse(m.cal.trim()) ?? 0;

          // date is millisecondsSinceEpoch (after AddTab fix)
          final date = DateTime.fromMillisecondsSinceEpoch(m.date).toLocal();
          final key =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

          byDay.putIfAbsent(key, () => _DayAcc(date: date));
          byDay[key]!.time += time;
          byDay[key]!.cal += cal;
        }

        final today = DateTime.now();
        weekChartData = List.generate(7, (i) {
          final day = today.subtract(Duration(days: 6 - i));
          final key =
              '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
          final acc = byDay[key];
          return DayChartData(
            date: day,
            totalTime: acc?.time ?? 0,
            totalCal: acc?.cal ?? 0,
          );
        });

        isLoadingWeek = false;
        notifyListeners();
      },
      onError: (e) {
        debugPrint("Week chart error: $e");
        isLoadingWeek = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    for (final sub in _daySubs) sub.cancel();
    _weekSub?.cancel();
    super.dispose();
  }
}

class _DayAcc {
  double time = 0;
  double cal = 0;
  final DateTime date;
  _DayAcc({required this.date});
}
