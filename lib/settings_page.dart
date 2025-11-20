import 'package:ai_lifestyle_twin/user_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_profile_service.dart';
import 'app_colors.dart';
import 'theme_provider.dart';

/* ----------------------------------------------------------
   Settings Page – Modern, calm, interactive
   ---------------------------------------------------------- */
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /* ---------------- Preferences ---------------- */
  bool _sound = true;
  bool _motivation = true;
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  void _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sound = prefs.getBool('sound') ?? true;
      _motivation = prefs.getBool('motivation') ?? true;
      _notifications = prefs.getBool('notifications') ?? true;
    });
  }

  void _saveBool(String key, bool value) async {
    await (await SharedPreferences.getInstance()).setBool(key, value);
  }

  /* ---------------------------------------------------------- */
  /* ---------------- Profile Card ---------------- */
Widget _profileCard(UserProfile user) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryTeal, AppColors.trustBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 32,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: AppColors.trustBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name.isNotEmpty ? user.name : 'User',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Level 7 • 2,340 XP',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserDetailsPage()),
              ),
              icon: const Icon(Icons.edit, color: AppColors.primaryTeal, size: 18),
              label: const Text(
                'Edit',
                style: TextStyle(
                  color: AppColors.primaryTeal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProfileService>(context).userProfile;
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.softGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.trustBlue),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/lifestyle_twin_logo.png',
                height: 28,
                width: 28,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Settings',
              style: TextStyle(
                color: AppColors.trustBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            /* 1. Profile Card */
            _profileCard(user),
            const SizedBox(height: 24),

            /* 2. Preferences */
            _section(
                'Experience', Icons.tune, AppColors.primaryTeal, _prefsTiles()),
            const SizedBox(height: 20),

            /* 3. AI Coach Settings */
            _section('AI Coach', Icons.psychology, AppColors.accentGreen,
                _aiTiles()),
            const SizedBox(height: 20),

            /* 4. Data & Privacy */
            _section('Data & Privacy', Icons.security, AppColors.trustBlue,
                _privacyTiles()),
            const SizedBox(height: 20),

            /* 5. Account */
            _section('Account', Icons.account_circle, AppColors.darkGray,
                _accountTiles()),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /* =========================================================
                         SECTIONS
     ========================================================= */
  Widget _section(
          String title, IconData icon, Color color, List<Widget> tiles) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.trustBlue),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...tiles,
          ],
        ),
      );

  /* ---------------- Tiles ---------------- */
  List<Widget> _prefsTiles() => [
        _switchTile('Sound Effects', 'Audio feedback during workouts',
            Icons.volume_up, _sound, (v) {
          setState(() => _sound = v);
          _saveBool('sound', v);
        }),
        _switchTile('Motivation Boosters', 'Confetti & XP celebrations',
            Icons.celebration, _motivation, (v) {
          setState(() => _motivation = v);
          _saveBool('motivation', v);
        }),
        _switchTile('Push Notifications', 'Daily check-ins & reminders',
            Icons.notifications_active, _notifications, (v) {
          setState(() => _notifications = v);
          _saveBool('notifications', v);
        }),
        _pickerTile('Daily Reminder', '7:30 AM', Icons.access_time, () {}),
        _pickerTile('Language', 'English', Icons.language, () {}),
      ];

  List<Widget> _aiTiles() => [
        _pickerTile(
            'Workout Intensity', 'Balanced', Icons.fitness_center, () {}),
        _pickerTile('Diet Preference', 'High-protein', Icons.restaurant, () {}),
        _pickerTile('Primary Goal', 'Lean muscle', Icons.emoji_events, () {}),
      ];

  List<Widget> _privacyTiles() => [
        _actionTile('Health Data Sources', 'Apple Health, Google Fit',
            Icons.favorite, () {}),
        _actionTile('Privacy Controls', 'Data usage & permissions',
            Icons.privacy_tip, () {}),
        _actionTile('Support & Feedback', 'Get help or share suggestions',
            Icons.support_agent, () {}),
      ];

  List<Widget> _accountTiles() => [
        _infoTile('App Version', 'v2.1.0', Icons.info_outline),
        const SizedBox(height: 12),
        _dangerTile('Reset All Data', 'Clear all progress', Icons.refresh,
            _showResetDialog),
        const SizedBox(height: 12),
        _dangerTile('Delete Account', 'Permanently delete account',
            Icons.delete_forever, _showDeleteDialog),
      ];

  /* ---------------- UI Helpers ---------------- */
  Widget _switchTile(String title, String subtitle, IconData icon, bool value,
          ValueChanged<bool> onChanged) =>
      Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.softGray,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primaryTeal, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.trustBlue)),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primaryTeal,
              activeTrackColor: AppColors.primaryTeal.withOpacity(0.3),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
      );

  Widget _pickerTile(
          String title, String value, IconData icon, VoidCallback onTap) =>
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryTeal, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.trustBlue)),
        subtitle: Text(value, style: const TextStyle(color: Colors.grey)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      );

  Widget _actionTile(
          String title, String subtitle, IconData icon, VoidCallback onTap) =>
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.trustBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.trustBlue, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.trustBlue)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      );

  Widget _infoTile(String title, String value, IconData icon) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.darkGray.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.darkGray, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: AppColors.trustBlue)),
        subtitle: Text(value, style: const TextStyle(color: Colors.grey)),
      );

  Widget _dangerTile(
          String title, String subtitle, IconData icon, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withOpacity(0.2), width: 1),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.red, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 16)),
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 13, color: Colors.red.withOpacity(0.8))),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.red),
            ],
          ),
        ),
      );

  /* ---------------- Modals ---------------- */
  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset All Data'),
        content: const Text(
          'This will clear all your progress and settings. This action cannot be undone.',
        ),
        actions: [
          TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data reset')),
              );
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
