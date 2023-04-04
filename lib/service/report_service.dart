import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/firebase_constant.dart';

class ReportService {
  final FirebaseFirestore firebaseFirestore;
  ReportService({required this.firebaseFirestore});
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
      FeedbackConstant.timestamp: DateTime.now().toString(),
    };
    await docRef.add(record);
  }
}
