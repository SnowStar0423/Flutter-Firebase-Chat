// ignore_for_file: unused_field

class FireStoreConstant {
  static const chatCollectionPath = 'chatroom';
  static const messageCollectionPath = 'message';
  static const recentChatCollectionPath = 'recentchat';
  static const userCollectionPath = 'users';
  static const recentPeerCollectionPath = 'peer';
  static const profileImagesPath = 'profileImages';
  static const feedbackCollectionPath = 'feedback';
  static const pushNotificationURL = 'https://fcm.googleapis.com/fcm/send';
  static const pushServerKey =
      "key=AAAAN1I-RfU:APA91bFf57hL8xDhY58ojdiSJ8J0WwYeco9yg0vafZId9IiUbyCrbrBw-LE3yN9JjeeyA5dLr1jTCZJ1wXtPVscpFlJZykVJYD69n4ShjvSP2KR7loWKfR227HQYR0YG7IFlG9Q-E4XN";
}

class ChatUserConstant {
  static const id = 'uid';
  static const photoUrl = 'photoUrl';
  static const displayName = 'displayName';
  static const phoneNumber = 'phoneNumber';
  static const deviceToken = 'deviceToken';
}

class ChatMessageConstant {
  static const idFrom = 'idFrom';
  static const idTo = 'idTo';
  static const timestamp = 'timestamp';
  static const content = 'content';
  static const type = 'type';
}

class FeedbackConstant {
  static const uid = 'uid';
  static const feedback = 'feedback';
  static const appVersion = 'appVersion';
  static const timestamp = 'timestamp';
}

class NotificationConstant {
  static const type = 'type';
  static const chat = 'chat';
  static const userFrom = 'userFrom';
  static const userTo = 'userTo';
  static const message = 'message';
}
