import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_control/layers/domain/entity/user_entity.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserEntity> getUser(String uidName) async {
    final doc = await _firestore.collection('accounts').doc(uidName).get();
    if (!doc.exists) throw Exception("Account topilmadi");
    final data = doc.data()!;
    return UserEntity(
      uidName: data['uidName'],
      role: data['role'],
      ownerUid: data['ownerUid'],
      displayName: data['displayName'],
      staff: data['staff'],
    );
  }

  Future<void> updateUser(String uidName, Map<String, dynamic> data) async {
    final docRef = _firestore.collection('accounts').doc(uidName);
    final snapshot = await docRef.get();
    if (!snapshot.exists) throw Exception("Account topilmadi");
    final ownerUid = snapshot['ownerUid'];
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    if (ownerUid != currentUid) throw Exception("Ruxsat yo‘q");
    await docRef.update(data);
  }

  Future<void> deleteUser(String uidName) async {
    final docRef = _firestore.collection('accounts').doc(uidName);
    final snapshot = await docRef.get();
    if (!snapshot.exists) throw Exception("Account topilmadi");
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    if (snapshot['ownerUid'] != currentUid) throw Exception("Ruxsat yo‘q");
    await docRef.delete();
  }
}