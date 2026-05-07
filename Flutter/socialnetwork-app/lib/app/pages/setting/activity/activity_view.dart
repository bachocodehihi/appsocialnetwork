import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialnetwork/app/widgets/card/today_card.dart';
import 'package:socialnetwork/app/widgets/chart/week_chart.dart';

class SettingActivityView extends StatefulWidget {
  const SettingActivityView({super.key});

  @override
  State<SettingActivityView> createState() => _SettingActivityViewState();
}

class _SettingActivityViewState extends State<SettingActivityView> {
  static const List<int> _weekDayMinutes = [1440, 1440, 1440, 1440, 1440, 1440, 1440];
  static const List<String> _weekDayLabels = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  int get _todayIndex => DateTime.now().weekday - 1;

  static String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0) return '${h}h ${m}m';
    return '${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    ));

    final cs = Theme.of(context).colorScheme;
    final todayMinutes = _weekDayMinutes[_todayIndex];
    final totalWeekMinutes = _weekDayMinutes.fold<int>(0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kIsWeb ? 0 : 24.w,
              vertical: 16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 20.sp,
                        color: cs.onSurface,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Time activity',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                TodayCard(
                  dayLabel: _weekDayLabels[_todayIndex],
                  minutes: todayMinutes,
                ),
                SizedBox(height: 20.h),
                Text(
                  'This week',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Total: ${_formatDuration(totalWeekMinutes)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: cs.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 12.h),
                WeekChart(
                  values: _weekDayMinutes,
                  labels: _weekDayLabels,
                  todayIndex: _todayIndex,
                  maxBarHeight: 160.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}