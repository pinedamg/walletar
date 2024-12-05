import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:walletar/features/accounts/models/account_model.dart';
import 'package:walletar/features/accounts/providers/accounts_provider.dart';

class AddAccountScreen extends ConsumerWidget {
  AddAccountScreen({Key? key}) : super(key: key);

  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration:
                  const InputDecoration(labelText: 'Nombre de la Cuenta'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _balanceController,
              decoration: const InputDecoration(labelText: 'Saldo Inicial'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                final balance =
                    double.tryParse(_balanceController.text.trim()) ?? 0.0;

                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('El nombre de la cuenta es obligatorio')),
                  );
                  return;
                }

                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuario no autenticado')),
                  );
                  return;
                }

                final account = Account(
                  id: '', // Firestore asignará el ID
                  name: name,
                  balance: balance,
                  createdAt: DateTime.now(),
                );

                await ref
                    .read(accountsRepositoryProvider)
                    .addAccount(user.uid, account.toFirestore());

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cuenta creada exitosamente')),
                );

                context.pop();
              },
              child: const Text('Crear Cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
