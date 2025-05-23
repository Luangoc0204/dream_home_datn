import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final bool isReadBySender;
  final bool isReadByReceiver;

  Message(
      {required this.senderId,
      required this.receiverId,
      required this.message,
      required this.timestamp,
      required this.isReadBySender,
        required this.isReadByReceiver
      });

  Map<String, dynamic> toJson() {
    return {
      'senderId' : senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'isReadBySender' : isReadBySender,
      'isReadByReceiver' : isReadByReceiver
    };
  }
}
class MessageShop{
  final String userId;
  final String shopId;
  final String message;
  final Timestamp timestamp;
  final bool isReadByUser;
  final bool isReadByShop;

  MessageShop(
      {required this.userId,
        required this.shopId,
        required this.message,
        required this.timestamp,
        required this.isReadByUser,
        required this.isReadByShop
      });

  Map<String, dynamic> toJson() {
    return {
      'senderId' : userId,
      'receiverId': shopId,
      'message': message,
      'timestamp': timestamp,
      'isReadBySender' : isReadByUser,
      'isReadByReceiver' : isReadByShop
    };
  }
}
