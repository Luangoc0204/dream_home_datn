import 'package:dreamhome/models/Message.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatViewModel extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //SEND MESSAGE
  Future<void> sendMessage(String senderId, String receiverId, String message, String receiverUserName,
      String senderUserName, String? receiverUserAvatar, String? senderUserAvatar) async {
    //get current user info
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp,
        isReadBySender: true,
        isReadByReceiver: false);

    //construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [senderId, receiverId];
    ids.sort(); //sort the ids (this ensures the chat room id is always the same for any pair of people)
    String chatRoomId = ids.join("_"); //combine the ids into a single string to use as a chatroomID

    // Add additional fields to the chat room document
    Map<String, dynamic> chatRoomData = {
      'receiverUserId': receiverId,
      'senderUserId': senderId,
      'receiverUserName': receiverUserName, // Replace with actual receiver user name
      'senderUserName': senderUserName, // Replace with actual sender user name
      'receiverUserAvatar': receiverUserAvatar, // Replace with actual receiver user avatar URL
      'senderUserAvatar': senderUserAvatar, // Replace with actual sender user avatar URL
    };

    // Update chat room document with additional fields
    await _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .set(chatRoomData, SetOptions(merge: true)); // Merge options to preserve existing fields

    // Add new message to database
    await _firebaseFirestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toJson());
  }

  //GET MESSAGE
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId, String currenUserId) {
    //construct chat room id from user ids (sorted to ensure it matches the id used when sending messages)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        // Update message status here
        if (doc.data()['receiverId'] == currenUserId && !doc.data()['isReadByReceiver']) {
          // Update isReadByReceiver to true
          doc.reference.update({'isReadByReceiver': true});
        } else if (doc.data()['senderId'] == currenUserId && !doc.data()['isReadBySender']) {
          // Update isReadBySender to true
          doc.reference.update({'isReadBySender': true});
        }
      }
      return querySnapshot;
    });
  }

  //GET CHATTING LIST
  Stream<QuerySnapshot> getChattingList(String userId) {
    return _firebaseFirestore
        .collection('chat_rooms')
        .where(Filter.or(
          Filter("receiverUserId", isEqualTo: userId),
          Filter("senderUserId", isEqualTo: userId),
        ))
        .snapshots();
  }

  //GET MESSAGE
  Stream<QuerySnapshot> getLastMessage(String userId, String otherUserId) {
    //construct chat room id from user ids (sorted to ensure it matches the id used when sending messages)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }

  Stream<int> getUnreadConversationsCount(String currentUserId) {
    try {
      // Lấy danh sách các cuộc trò chuyện của người dùng
      return _firebaseFirestore
          .collection('chat_rooms')
          .where(Filter.or(
        Filter("receiverUserId", isEqualTo: currentUserId),
        Filter("senderUserId", isEqualTo: currentUserId),
      ))
          .snapshots()
          .asyncMap((querySnapshot) async {
        int unreadCount = 0;
        // Lặp qua từng cuộc trò chuyện và kiểm tra tin nhắn chưa đọc
        for (var document in querySnapshot.docs) {
          // Lấy danh sách tin nhắn trong cuộc trò chuyện
          var messagesSnapshot = await document.reference.collection('messages').get();
          // Kiểm tra xem có tin nhắn nào chưa đọc không
          bool hasUnreadMessages = messagesSnapshot.docs.any((messageDoc) {
            var messageData = messageDoc.data();
            if (messageData['receiverId'] == currentUserId && !messageData['isReadByReceiver']) {
              return true;
            }
            return false;
          });
          // Nếu có tin nhắn chưa đọc, tăng biến đếm
          if (hasUnreadMessages) {
            unreadCount++;
          }
        }
        return unreadCount;
      });
    } catch (error) {
      print("Error getting unread conversations count: $error");
      throw error; // Ném lỗi để bắt ngoại lệ ở nơi gọi
    }
  }

  //SHOP
  //SEND MESSAGE
  Future<void> sendMessageShop(String senderId, String receiverId, String message, String receiverUserName,
      String senderUserName, String? receiverUserAvatar, String? senderUserAvatar) async {
    //get current user info
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp,
        isReadBySender: true,
        isReadByReceiver: false);

    //construct chat room id from current user id and receiver id (sorted to ensure uniqueness)
    List<String> ids = [senderId, receiverId];
    ids.sort(); //sort the ids (this ensures the chat room id is always the same for any pair of people)
    String chatRoomId = ids.join("_"); //combine the ids into a single string to use as a chatroomID

    // Add additional fields to the chat room document
    Map<String, dynamic> chatRoomData = {
      'receiverUserId': receiverId,
      'senderUserId': senderId,
      'receiverUserName': receiverUserName, // Replace with actual receiver user name
      'senderUserName': senderUserName, // Replace with actual sender user name
      'receiverUserAvatar': receiverUserAvatar, // Replace with actual receiver user avatar URL
      'senderUserAvatar': senderUserAvatar, // Replace with actual sender user avatar URL
    };

    // Update chat room document with additional fields
    await _firebaseFirestore
        .collection('chat_shop_rooms')
        .doc(chatRoomId)
        .set(chatRoomData, SetOptions(merge: true)); // Merge options to preserve existing fields

    // Add new message to database
    await _firebaseFirestore.collection('chat_shop_rooms').doc(chatRoomId).collection('messages').add(newMessage.toJson());
  }

  //GET MESSAGE
  Stream<QuerySnapshot> getMessagesShop(String userId, String otherUserId, String currenUserId) {
    //construct chat room id from user ids (sorted to ensure it matches the id used when sending messages)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firebaseFirestore
        .collection('chat_shop_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        // Update message status here
        if (doc.data()['receiverId'] == currenUserId && !doc.data()['isReadByReceiver']) {
          // Update isReadByReceiver to true
          doc.reference.update({'isReadByReceiver': true});
        } else if (doc.data()['senderId'] == currenUserId && !doc.data()['isReadBySender']) {
          // Update isReadBySender to true
          doc.reference.update({'isReadBySender': true});
        }
      }
      return querySnapshot;
    });
  }

  //GET CHATTING LIST
  Stream<QuerySnapshot> getChattingListShop(String userId) {
    return _firebaseFirestore
        .collection('chat_shop_rooms')
        .where(Filter.or(
      Filter("receiverUserId", isEqualTo: userId),
      Filter("senderUserId", isEqualTo: userId),
    ))
        .snapshots();
  }

  //GET MESSAGE
  Stream<QuerySnapshot> getLastMessageShop(String userId, String otherUserId) {
    //construct chat room id from user ids (sorted to ensure it matches the id used when sending messages)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firebaseFirestore
        .collection('chat_shop_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots();
  }

  Stream<int> getUnreadConversationsCountShop(String currentUserId) {
    try {
      // Lấy danh sách các cuộc trò chuyện của người dùng
      return _firebaseFirestore
          .collection('chat_shop_rooms')
          .where(Filter.or(
        Filter("receiverUserId", isEqualTo: currentUserId),
        Filter("senderUserId", isEqualTo: currentUserId),
      ))
          .snapshots()
          .asyncMap((querySnapshot) async {
        int unreadCount = 0;
        // Lặp qua từng cuộc trò chuyện và kiểm tra tin nhắn chưa đọc
        for (var document in querySnapshot.docs) {
          // Lấy danh sách tin nhắn trong cuộc trò chuyện
          var messagesSnapshot = await document.reference.collection('messages').get();
          // Kiểm tra xem có tin nhắn nào chưa đọc không
          bool hasUnreadMessages = messagesSnapshot.docs.any((messageDoc) {
            var messageData = messageDoc.data();
            if (messageData['receiverId'] == currentUserId && !messageData['isReadByReceiver']) {
              return true;
            }
            return false;
          });
          // Nếu có tin nhắn chưa đọc, tăng biến đếm
          if (hasUnreadMessages) {
            unreadCount++;
          }
        }
        return unreadCount;
      });
    } catch (error) {
      print("Error getting unread conversations count: $error");
      throw error; // Ném lỗi để bắt ngoại lệ ở nơi gọi
    }
  }

}
