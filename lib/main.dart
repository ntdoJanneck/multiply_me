import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multiply_me/colors/lib_color_schemes.g.dart';
import 'components/practise_menu.dart';
import 'components/settings_screen.dart';
import 'components/statistics_screen.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

void main() {
  runApp(const MultiplyMe());
}

class MultiplyMe extends StatelessWidget {
  const MultiplyMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en", ""),
        Locale("de", ""),
      ],
      darkTheme: ThemeData(
          fontFamily: "Roboto",
          useMaterial3: true,
          colorScheme: darkColorScheme,
          brightness: Brightness.dark),
      theme: ThemeData(
          fontFamily: "Roboto",
          useMaterial3: true,
          colorScheme: lightColorScheme,
          brightness: Brightness.light),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 1;
  final tabs = [
    const Center(child: StatisticsScreen()),
    const Center(
      child: PractiseMenu(),
    ),
    const Center(child: SettingsScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    var localization =
        Localizations.of<AppLocalizations>(context, AppLocalizations);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(localization!.appTitle),
      ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.assessment_outlined),
            label: localization.statisticsTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_outlined),
            label: localization.practiseTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            label: localization.settingsTitle,
          )
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}
