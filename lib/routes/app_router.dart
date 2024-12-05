import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar/features/accounts/screens/add_account_screen.dart';
import 'package:walletar/features/auth/screens/login_screen.dart';
import 'package:walletar/features/auth/screens/register_screen.dart';
import 'package:walletar/features/main/screens/home_screen.dart';

// Proveedor de rutas
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation:
        FirebaseAuth.instance.currentUser != null ? '/home' : '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add-account',
        builder: (context, state) => AddAccountScreen(),
      ),
    ],
  );
});
