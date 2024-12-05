import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:walletar/features/accounts/models/account_model.dart';

class AccountsRepository {
  final FirebaseFirestore _firestore;

  AccountsRepository(this._firestore);

  Future<void> addAccount(
      String userId, Map<String, dynamic> accountData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .add(accountData);
  }

  Stream<List<Account>> getAccounts(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('accounts')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Account.fromFirestore(
                  data, doc.id); // Incluye el ID del documento
            }).toList());
  }
}
