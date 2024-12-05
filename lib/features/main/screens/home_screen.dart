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
                subtitle:
                    Text('Saldo: \$${account.balance.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        context.push('/edit-account',
                            extra: account); // Navegar a la pantalla de edición
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmar eliminación'),
                              content: Text(
                                  '¿Estás seguro de que deseas eliminar la cuenta "${account.name}"?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {
                          await ref
                              .read(accountsRepositoryProvider)
                              .deleteAccount(user.uid, account.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cuenta eliminada')),
                          );
                        }
                      },
                    ),
                  ],
                ),
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
