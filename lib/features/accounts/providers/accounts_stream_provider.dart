import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:walletar/features/accounts/models/account_model.dart';
import 'package:walletar/features/accounts/providers/accounts_provider.dart';

final accountsStreamProvider =
    StreamProvider.family<List<Account>, String>((ref, userId) {
  final accountsRepo = ref.watch(accountsRepositoryProvider);
  return accountsRepo.getAccounts(userId);
});
