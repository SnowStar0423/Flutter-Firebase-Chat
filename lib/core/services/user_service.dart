import 'package:chat_app/model/chat_user.dart';
import 'package:chat_app/core/utils/firebase_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  UserService({required this.firebaseFirestore});

  final FirebaseFirestore firebaseFirestore;

  Future<void> addUser(ChatUser user) async {
    firebaseFirestore
        .collection(FireStoreConstant.userCollectionPath)
        .doc(user.id)
        .set(user.toJson());
  }

  Future<bool> checkUserExist(String userId) async {
    final QuerySnapshot result = await firebaseFirestore
        .collection(FireStoreConstant.userCollectionPath)
        .where(ChatUserConstant.id, isEqualTo: userId)
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUsers(
      {required String searchText, int limit = 20}) async {
    final search = searchText.toLowerCase();
    if (searchText.isNotEmpty) {
      return await firebaseFirestore
          .collection(FireStoreConstant.userCollectionPath)
          .where(ChatUserConstant.displayNameLowerCase,
              isGreaterThanOrEqualTo: search)
          .where(ChatUserConstant.displayNameLowerCase,
              isLessThan: '${search}z')
          .limit(limit > 10 ? 10 : limit)
          .get();
    } else {
      return await firebaseFirestore
          .collection(FireStoreConstant.userCollectionPath)
          .limit(limit)
          .get();
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUsersByIds(
      {List<String> ids = const [], int limit = 10}) async {
    if (ids.isNotEmpty) {
      return await firebaseFirestore
          .collection(FireStoreConstant.userCollectionPath)
          .where(ChatUserConstant.id, whereIn: ids)
          .limit(limit > 10 ? 10 : limit)
          .get();
    } else {
      return await firebaseFirestore
          .collection(FireStoreConstant.userCollectionPath)
          .limit(limit)
          .get();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> loadUsersByIds(
      {List<String> ids = const [], int limit = 10}) {
    if (ids.isNotEmpty) {
      return firebaseFirestore
          .collection(FireStoreConstant.userCollectionPath)
          .where(ChatUserConstant.id, whereIn: ids)
          .limit(limit > 10 ? 10 : limit)
          .snapshots();
    } else {
      return firebaseFirestore
          .collection(FireStoreConstant.userCollectionPath)
          .limit(limit)
          .snapshots();
    }
  }

  Future<void> updateUserOnlineStatus(String userId, String status) async {
    await firebaseFirestore
        .collection(FireStoreConstant.userCollectionPath)
        .doc(userId)
        .update({ChatUserConstant.onlineStatus: status});
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> loadUserOnlineStatus(
      String userId) {
    return firebaseFirestore
        .collection(FireStoreConstant.userCollectionPath)
        .doc(userId)
        .snapshots();
  }

  Future<void> updateUser(String userId, Map<String, dynamic> map) async {
    await firebaseFirestore
        .collection(FireStoreConstant.userCollectionPath)
        .doc(userId)
        .update(map);
  }
}
