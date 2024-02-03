import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/core/utils/firebase_constant.dart';

class ReportService {
  ReportService({required this.firebaseFirestore});

  final FirebaseFirestore firebaseFirestore;

  addFeedback(
      {required String userId,
      required String content,
      String appVersion = ""}) async {
    final docRef =
        firebaseFirestore.collection(FireStoreConstant.feedbackCollectionPath);
    final record = {
      FeedbackConstant.uid: userId,
      FeedbackConstant.feedback: content,
      FeedbackConstant.appVersion: appVersion,
      FeedbackConstant.timestamp: DateTime.now().toString(),
    };
    await docRef.add(record);
  }

  reportUser(
      {required String userId,
      required String reportedUserId,
      String content = ""}) async {
    final docRef = firebaseFirestore
        .collection(FireStoreConstant.userReportCollectionPath);
    final record = {
      UserReportConstant.userId: userId,
      UserReportConstant.reportedUserId: reportedUserId,
      UserReportConstant.content: content,
      UserReportConstant.timestamp: DateTime.now().toString(),
    };
    await docRef.add(record);
  }

  blockPeer(
      {required String userId,
      required String peerId,
      String content = ""}) async {
    _addBlockedRecord(userId: userId, peerId: peerId);
    _addIsBlockedRecord(userId: userId, peerId: peerId);
  }

  _addBlockedRecord(
      {required String userId,
      required String peerId,
      String content = ""}) async {
    final docRef = firebaseFirestore
        .collection(FireStoreConstant.userBlockCollectionPath)
        .doc(userId)
        .collection(FireStoreConstant.blockedCollectionPath)
        .doc(peerId);
    final record = {
      UserBlcokConstant.userId: userId,
      UserBlcokConstant.peerId: peerId,
      UserBlcokConstant.content: content,
      UserBlcokConstant.timestamp: DateTime.now().toString(),
    };
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(docRef, record);
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  _addIsBlockedRecord(
      {required String userId,
      required String peerId,
      String content = ""}) async {
    final docRef = firebaseFirestore
        .collection(FireStoreConstant.userBlockCollectionPath)
        .doc(peerId)
        .collection(FireStoreConstant.isBlockedCollectionPath)
        .doc(userId);
    final record = {
      UserBlcokConstant.userId: userId,
      UserBlcokConstant.peerId: peerId,
      UserBlcokConstant.content: content,
      UserBlcokConstant.timestamp: DateTime.now().toString(),
    };
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(docRef, record);
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  unblockPeer({required String userId, required String peerId}) async {
    _removeBlockedRecord(userId: userId, peerId: peerId);
    _removeIsBlockedRecord(userId: userId, peerId: peerId);
  }

  _removeBlockedRecord({required String userId, required String peerId}) async {
    final docRef = firebaseFirestore
        .collection(FireStoreConstant.userBlockCollectionPath)
        .doc(userId)
        .collection(FireStoreConstant.blockedCollectionPath)
        .doc(peerId);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.delete(docRef);
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  _removeIsBlockedRecord(
      {required String userId, required String peerId}) async {
    final docRef = firebaseFirestore
        .collection(FireStoreConstant.userBlockCollectionPath)
        .doc(peerId)
        .collection(FireStoreConstant.isBlockedCollectionPath)
        .doc(userId);
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.delete(docRef);
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> checkIsBlocked(
      {required String userId, required String peerId}) async {
    final result = await firebaseFirestore
        .collection(FireStoreConstant.userBlockCollectionPath)
        .doc(userId)
        .collection(FireStoreConstant.isBlockedCollectionPath)
        .doc(peerId)
        .get();
    return result.exists;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> checkIsUserBlocked(
      {required String userId, required String peerId}) {
    return firebaseFirestore
        .collection(FireStoreConstant.userBlockCollectionPath)
        .doc(userId)
        .collection(FireStoreConstant.isBlockedCollectionPath)
        .doc(peerId)
        .snapshots();
  }

  Future<bool> checkIsBlockedPeer(
      {required String userId, required String peerId}) async {
    final result = await firebaseFirestore
        .collection(FireStoreConstant.userBlockCollectionPath)
        .doc(userId)
        .collection(FireStoreConstant.blockedCollectionPath)
        .doc(peerId)
        .get();
    return result.exists;
  }
}
