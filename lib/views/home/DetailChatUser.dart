import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/ChatViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DetailChatUserPage extends StatefulWidget {
  const DetailChatUserPage(
      {super.key, required this.receiverUserName, required this.receiverUserId, this.receiverUserAvatar, required this.senderUserName, required this.senderUserId, this.senderUserAvatar, required this.currentUserId});

  final String receiverUserName;
  final String receiverUserId;
  final String? receiverUserAvatar;
  final String senderUserName;
  final String senderUserId;
  final String? senderUserAvatar;
  final String currentUserId;
  @override
  State<DetailChatUserPage> createState() => _DetailChatUserPageState();
}

class _DetailChatUserPageState extends State<DetailChatUserPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatViewModel _chatViewModel = ChatViewModel();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatViewModel.sendMessage(widget.senderUserId,widget.receiverUserId, _messageController.text.trim(), widget.receiverUserName,  widget.senderUserName,  widget.receiverUserAvatar,  widget.senderUserAvatar,);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserName),
      ),
      body: Column(
        children: [Expanded(child: _buildMessageList()), _buildMessageInput()],
      ),
    );
  }

  Widget _buildMessageList() {
    print("receiverUserId: " + widget.receiverUserId);
    return StreamBuilder(
        stream: _chatViewModel.getMessages(widget.receiverUserId, widget.senderUserId, widget.currentUserId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting){
            return Text("Loading ...");
          }
          return ListView.builder(
            controller: _scrollController, // Thêm ScrollController vào ListView
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return _buildMessageItem(snapshot.data!.docs[index]);
            },
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align the messages to the right if the sender is the current user, otherwise to the left
    bool isSender = (data['senderId'] == widget.senderUserId);
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicWidth(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              alignment: Alignment.center,
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
              decoration: BoxDecoration(
                  color: isSender ? mainColor : Colors.white,
                border: Border.all(
                  color: isSender ? mainColor : Colors.black,
                  width: 1
                ),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Text(data['message'], style: TextStyle(color: isSender ? Colors.white : Colors.black, fontSize: 18), ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _messageController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15.0),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.6),
                  hintText: 'Enter your message ...',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 1.5),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: mainColor, width: 1.5),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: IconButton(
                onPressed: () async {
                  debugPrint("SEND MESSAGE");
                  sendMessage();
                  // await Future.delayed(Duration(seconds: 1));
                  // _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                },
                icon: Icon(Icons.send_rounded, color: mainColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
