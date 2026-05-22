import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/shell/app_shell.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/screens/login_screen.dart';

void main() { runApp(const HireOpsApp()); }

class HireOpsApp extends StatelessWidget {
  const HireOpsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(),
      child: MaterialApp(
        title: 'HireOps',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A73E8)),
          textTheme:   GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
        ),
        home: const SplashRouter(),
      ),
    );
  }
}

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});
  @override State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  final _storage = const FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }
  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    final token = await _storage.read(key: 'auth_token');
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const AppShell()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => BlocProvider(
            create: (_) => AuthBloc(),
            child: const _LoginWrapper(),
          )));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A73E8),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.work_outline, color: Colors.white, size: 56),
        ),
        const SizedBox(height: 20),
        Text('HireOps', style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        Text('CV Management Platform', style: GoogleFonts.poppins(
            color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 40),
        const CircularProgressIndicator(color: Colors.white),
      ])),
    );
  }
}

class _LoginWrapper extends StatelessWidget {
  const _LoginWrapper();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AppShell()),
            (route) => false,
          );
        }
      },
      child: const LoginScreen(),
    );
  }
}
