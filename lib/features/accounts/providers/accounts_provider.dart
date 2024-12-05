import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walletar/features/accounts/providers/accounts_firestore_provider.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final accountsRepositoryProvider = Provider((ref) {
  final firestore = ref.watch(firestoreProvider);
  return AccountsRepository(firestore);
});
