import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/light_theme.dart';
import '../widgets/light/add_transaction_sheet.dart';
import '../widgets/light/light_bottom_nav.dart';
import 'light_home_screen.dart';
import 'light_plan_screen.dart';
import 'light_report_screen.dart';
import 'settings_screen.dart';

class LightMainWrapper extends StatefulWidget {
  const LightMainWrapper({super.key});

  @override
  State<LightMainWrapper> createState() => _LightMainWrapperState();
}

class _LightMainWrapperState extends State<LightMainWrapper> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: LightTheme.data,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        // Home has a purple header, so its status bar icons are white.
        value: _index == 0 ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: _index,
            children: [
              const LightHomeScreen(),
              LightReportScreen(onBack: () => _go(0)),
              LightPlanScreen(onBack: () => _go(0)),
              const SettingsScreen(),
            ],
          ),
          bottomNavigationBar: LightBottomNav(
            currentIndex: _index,
            onSelected: _go,
            onAdd: () async {
              final saved = await showAddTransactionSheet(context);
              if (saved == true) _go(0);
            },
          ),
        ),
      ),
    );
  }
}