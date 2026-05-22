import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/candidates/screens/candidates_screen.dart';
import '../features/jobs/screens/jobs_screen.dart';
import '../features/activity/screens/activity_feed_screen.dart';
import '../features/settings/screens/settings_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int     _currentIndex = 0;
  String  _userName     = '';
  String  _companyName  = '';
  String  _userRole     = 'recruiter';
  bool    _isAdmin      = false;

  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userJson    = await _storage.read(key: 'auth_user');
    final companyJson = await _storage.read(key: 'auth_company');

    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        _userName  = user['name']  ?? '';
        _userRole  = user['role']  ?? 'recruiter';
        _isAdmin   = _userRole == 'admin';
      });
    }
    if (companyJson != null) {
      final company = jsonDecode(companyJson);
      setState(() { _companyName = company['name'] ?? ''; });
    }
  }

  List<Widget> get _screens => [
    DashboardScreen(userName: _userName, companyName: _companyName),
    const CandidatesScreen(),
    const JobsScreen(),
    const ActivityFeedScreen(),
    SettingsScreen(isAdmin: _isAdmin),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12, offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(0, Icons.dashboard_outlined,     Icons.dashboard,        'Dashboard'),
              _navItem(1, Icons.people_outline,          Icons.people,            'Candidates'),
              _navItem(2, Icons.work_outline,            Icons.work,              'Jobs'),
              _navItem(3, Icons.history_outlined,        Icons.history,           'Activity'),
              _navItem(4, Icons.settings_outlined,       Icons.settings,          'Settings'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1A73E8).withOpacity(0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? const Color(0xFF1A73E8) : Colors.grey.shade500,
            size: 24,
          ),
          const SizedBox(height: 3),
          Text(label, style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? const Color(0xFF1A73E8) : Colors.grey.shade500,
          )),
        ]),
      ),
    );
  }
}
