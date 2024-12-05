import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authProvider = Provider((ref) => FirebaseAuth.instance);

final registerProvider = FutureProvider.family<void, Map<String, String>>(
  (ref, data) async {
    final auth = ref.watch(authProvider);
    final email = data['email']!;
    final password = data['password']!;

    await auth.createUserWithEmailAndPassword(email: email, password: password);
  },
);

final loginProvider = FutureProvider.family<void, Map<String, String>>(
  (ref, data) async {
    final auth = ref.watch(authProvider);
    final email = data['email']!;
    final password = data['password']!;

    await auth.signInWithEmailAndPassword(email: email, password: password);
  },
);
