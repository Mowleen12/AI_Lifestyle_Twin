import 'package:ai_lifestyle_twin/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'home_page.dart';
import 'meals_page.dart';
import 'coach_page.dart';
import 'settings_page.dart';
import 'user_profile_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileService()),
      ],
      child: const LifestyleTwinApp(),
    ),
  );
}

class LifestyleTwinApp extends StatelessWidget {
  const LifestyleTwinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lifestyle Twin',
      theme: ThemeData(
        primaryColor: const Color(0xFF1FBAB4), // Exact logo teal
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: _createTealSwatch(),
          accentColor: const Color(0xFF1FBAB4),
        ).copyWith(
          secondary: const Color(0xFF1FBAB4),
          surface: Colors.white,
          background: const Color(0xFFF8FAFA), // Very light teal-gray
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFA),
        fontFamily: 'Inter',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF1FBAB4)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2C3E50),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1FBAB4),
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: const Color(0xFF1FBAB4).withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF2C3E50)),
          bodyMedium: TextStyle(color: Color(0xFF2C3E50)),
          titleLarge: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

  MaterialColor _createTealSwatch() {
    return const MaterialColor(
      0xFF1FBAB4,
      <int, Color>{
        50: Color(0xFFE4F7F6),
        100: Color(0xFFBCECE9),
        200: Color(0xFF90DFDB),
        300: Color(0xFF64D2CD),
        400: Color(0xFF42C8C2),
        500: Color(0xFF1FBAB4), // Primary
        600: Color(0xFF1BAB9F),
        700: Color(0xFF179988),
        800: Color(0xFF138871),
        900: Color(0xFF0B6A4C),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    MealsPage(),
    CoachPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1FBAB4).withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu),
                label: 'Meals',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.directions_run),
                label: 'Coach',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF1FBAB4),
            unselectedItemColor: const Color(0xFF9CA3AF),
            onTap: _onItemTapped,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
