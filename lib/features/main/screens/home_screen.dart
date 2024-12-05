import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:walletar/features/accounts/providers/accounts_provider.dart';
import 'package:walletar/features/accounts/screens/add_account_screen.dart';
import 'package:walletar/features/auth/screens/login_screen.dart';
import 'package:walletar/features/accounts/providers/accounts_firestore_provider.dart';
import 'package:walletar/features/accounts/providers/accounts_stream_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(child: Text('Usuario no autenticado')),
      );
    }

    final accountsAsyncValue = ref.watch(accountsStreamProvider(user.uid));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              context.go('/login');
            },
          ),
        ],
      ),
      body: accountsAsyncValue.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return const Center(child: Text('No hay cuentas registradas.'));
          }

          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return ListTile(
                title: Text(account.name),
                // subtitle: Text('Saldo: \$${account.balance}'),
                subtitle:
                    Text('Saldo: \$${account.balance.toStringAsFixed(2)}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-account');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
