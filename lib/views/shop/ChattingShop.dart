import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Shop.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/ChatViewModel.dart';
import 'package:dreamhome/views/shop/DetailChatShop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class ChattingShopPage extends StatefulWidget {
  const ChattingShopPage({super.key, this.currentUser, this.currentShop});
  final User? currentUser;
  final Shop? currentShop;
  @override
  State<ChattingShopPage> createState() => _ChattingShopPageState();
}

class _ChattingShopPageState extends State<ChattingShopPage> {
  final ChatViewModel _chatViewModel = ChatViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery
                .of(context)
                .padding
                .top,
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: FaIcon(FontAwesomeIcons.chevronLeft, size: 25, color: Colors.black)),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Chats",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey.withOpacity(0.5),
          ),
          Expanded(
            child: StreamBuilder(
                stream: _chatViewModel.getChattingListShop(widget.currentUser == null ? widget.currentShop!.id : widget.currentUser!.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: mainColor,));
                  }
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: snapshot.data!.docs.map((document) => _buildItemChat(document)).toList(),
                  );
                }
            ),
          )
        ],
      ),
    );
  }
  Widget _buildItemChat(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    bool isSender = widget.currentUser == null ? (data['senderUserId'] == widget.currentShop!.id): (data['senderUserId'] == widget.currentUser!.id);
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          screen: DetailChatShopPage(
            receiverUserName: isSender ? data['receiverUserName'] : data['senderUserName'],
            receiverUserId: isSender ? data['receiverUserId'] : data['senderUserId'],
            receiverUserAvatar: isSender ? data['receiverUserAvatar'] : data['senderUserAvatar'],
            senderUserName: isSender ? data['senderUserName'] : data['receiverUserName'],
            senderUserId: isSender ? data['senderUserId'] : data['receiverUserId'],
            senderUserAvatar: isSender ? data['senderUserAvatar'] : data['receiverUserAvatar'],
            currentUserId: widget.currentUser == null ? widget.currentShop!.id : widget.currentUser!.id,

          ),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1
                )
            )
        ),
        child: Row(
          children: [
            ClipOval(
                child: isSender
                    ? (data['receiverUserAvatar'] == null ? widget.currentUser == null ? Image.asset(
                  'assets/img_shop_empty.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ) : Image.asset(
                  'assets/img_avatar_empty.jpg',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
                    : widget.currentUser == null ? Image.network(
                  '${URLImage}user/' + data['receiverUserAvatar'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ) : Image.network(
                  '${URLImage}shop/' + data['receiverUserAvatar'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )) : (data['senderUserAvatar'] == null ? widget.currentUser == null ? Image.asset(
                  'assets/img_shop_empty.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ) : Image.asset(
                  'assets/img_avatar_empty.jpg',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )
                    : widget.currentUser == null ? Image.network(
                  '${URLImage}user/' + data['senderUserAvatar'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ) : Image.network(
                  '${URLImage}shop/' + data['senderUserAvatar'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ))
            ),
            SizedBox(width: 10.w,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSender ? data['receiverUserName'] : data['senderUserName'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  StreamBuilder(
                      stream: _chatViewModel.getLastMessageShop(data['senderUserId'], data['receiverUserId']),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error ${snapshot.error}');
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator(color: mainColor,));
                        }
                        int unreadMessageCount = 0;
                        var lastDoc = snapshot.data!.docs.first;
                        Map<String, dynamic> data = lastDoc.data() as Map<String, dynamic>;
                        String lastMessage = data['message'];
                        for (var messageSnapshot in snapshot.data!.docs ) {
                          // Lấy thông tin tin nhắn từ snapshot
                          Map<String, dynamic> dataMessage = messageSnapshot.data() as Map<String, dynamic>;
                          String messageData = messageSnapshot['message'];
                          // Kiểm tra điều kiện và đếm số tin nhắn chưa đọc
                          if (widget.currentShop == null)
                            {
                              if ( widget.currentUser!.id == dataMessage['receiverId']   && !dataMessage['isReadByReceiver'] ) {
                                unreadMessageCount++;
                              }
                            }
                          else if (widget.currentUser == null){
                            if ( widget.currentShop!.id == dataMessage['receiverId']  && !dataMessage['isReadByReceiver'] ) {
                              unreadMessageCount++;
                            }
                            }
                          // Kiểm tra số lượng tin nhắn chưa đọc, nếu đủ 10 tin thì dừng vòng lặp
                          if (unreadMessageCount >= 10) {
                            break;
                          }
                        }
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                lastMessage,
                                style: TextStyle(fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(width: 10.w,),
                            unreadMessageCount == 0 ? SizedBox() : ClipOval(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  height: 20,
                                  color: Colors.red,
                                  child: Text(
                                    unreadMessageCount < 10 ? unreadMessageCount.toString() : "9+",
                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                  ),
                                )),
                            SizedBox(width: 10.w,),
                          ],
                        );
                      }
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
