import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_control/layers/domain/entity/user_entity.dart';

class UserService {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _accounts =
      FirebaseFirestore.instance.collection('accounts');

  /// 🔹 Firestore'dan user olish
  Future<UserEntity> getUser(String uidName) async {
    final doc = await _accounts.doc(uidName).get();
    if (!doc.exists) throw Exception("Account topilmadi");
    return UserEntity.fromJson(doc.data() as Map<String, dynamic>);
  }

  /// 🔹 User update qilish
  Future<void> updateUser(String uidName, Map<String, dynamic> data) async {
    final docRef = _accounts.doc(uidName);
    final snapshot = await docRef.get();
    if (!snapshot.exists) throw Exception("Account topilmadi");

    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    final ownerUid = snapshot['ownerUid'] as String;

    if (ownerUid != currentUid) throw Exception("Ruxsat yo‘q");

    await docRef.update(data);
  }

  /// 🔹 User o‘chirish
  Future<void> deleteUser(String uidName) async {
    final docRef = _accounts.doc(uidName);
    final snapshot = await docRef.get();
    if (!snapshot.exists) throw Exception("Account topilmadi");

    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    final ownerUid = snapshot['ownerUid'] as String;

    if (ownerUid != currentUid) throw Exception("Ruxsat yo‘q");

    await docRef.delete();
  }
}