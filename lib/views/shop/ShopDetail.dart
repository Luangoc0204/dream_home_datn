import 'dart:ui';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Shop.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/ProductViewModel.dart';
import 'package:dreamhome/viewmodels/ShopViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/home/AddEditPost.dart';
import 'package:dreamhome/views/shop/AddEditProduct.dart';
import 'package:dreamhome/views/shop/ChattingShop.dart';
import 'package:dreamhome/views/shop/OrdersForShop.dart';
import 'package:dreamhome/views/shop/ProducBox.dart';
import 'package:dreamhome/views/shop/UpdateShop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ShopDetailPage extends StatefulWidget {
  const ShopDetailPage({super.key});

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  late Shop shop;
  User? currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
    _getCurrentUser();
  }
  void _getCurrentUser() async {
    currentUser = await context.read<UserViewModel>().currentUser;
  }
  void getProducts() async {
    shop = await context.read<ShopViewModel>().currentShop;
    await context.read<ProductViewModel>().getAllProductByShop(shop.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FB),
      body: Column(
        children: [
          Container(
            child:Consumer<ShopViewModel>(builder: (context, shopViewModel, child) {
              return Stack(
                children: [
                  Container(
                    height: 200.h,
                    decoration: BoxDecoration(
                      image: shopViewModel.currentShop!.background == null
                          ? DecorationImage(
                        image: AssetImage("assets/img_background_shop.jpg"),
                        fit: BoxFit.cover,
                      )
                          : DecorationImage(
                        image: NetworkImage('${URLImage}shop/${shopViewModel.currentShop!.background}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.grey.withOpacity(1), // Màu chuyển đội từ dưới lên
                            mainColor.withOpacity(0),
                            // Màu trong suốt
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10.h,
                    left: 10.w,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10.w, ),
                            child: ClipOval(
                                child: shopViewModel.currentShop!.avatar == null
                                    ? Image.asset(
                                  'assets/img_shop_empty.png',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                )
                                    : Image.network(
                                  '${URLImage}shop/${shopViewModel.currentShop!.avatar}', // Thay thế bằng URL của ảnh
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(
                                  left: 10.w,
                                  bottom: 5.h
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          shopViewModel.currentShop.name,
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                          onPressed: (){
                                            pushNewScreen(
                                              context,
                                              screen: const UpdateShopPage(),
                                              withNavBar: false, // OPTIONAL VALUE. True by default.
                                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                            );
                                          },
                                            icon: FaIcon(FontAwesomeIcons.penToSquare, size: 16, color: Colors.white)
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(shopViewModel.currentShop!.totalProduct.toString() + " Products", style: TextStyle(color: Colors.white, fontSize: 16),),
                                      ],
                                    )
                                  ],
                                )
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          Column(
                            children: [
                              Container(
                                constraints: BoxConstraints(minWidth: 70),
                                padding: EdgeInsets.zero,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                                    backgroundColor: mainColor,
                                    elevation:0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5), // Đặt bo góc cho border
                                    ),
                                  ),
                                  onPressed: () {
                                    pushNewScreen(
                                      context,
                                      screen: OrdersForShopPage(shop: shopViewModel.currentShop,),
                                      withNavBar: false, // OPTIONAL VALUE. True by default.
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(FontAwesomeIcons.truckFast, size: 14, color: Colors.white),
                                      SizedBox(width: 4.w,),
                                      Text("Order", style: TextStyle(color: Colors.white, fontSize: 14),)
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                constraints: BoxConstraints(minWidth: 70),
                                padding: EdgeInsets.zero,

                                child: ElevatedButton(

                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                                      backgroundColor: mainColor,
                                      elevation:0,
                                      shape:RoundedRectangleBorder(
                                          borderRadius:BorderRadius.circular(5)
                                      )
                                  ),
                                  onPressed: () {
                                    if (currentUser != null){
                                      pushNewScreen(
                                        context,
                                        screen: ChattingShopPage(currentShop: shopViewModel.currentShop,),
                                        withNavBar: false, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      );
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FaIcon(FontAwesomeIcons.facebookMessenger, size: 14, color: Colors.white),
                                      SizedBox(width: 4.w,),
                                      Text("Chat", style: TextStyle(color: Colors.white, fontSize: 14),)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 20.w,)
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top - 10.h,
                      left: 5.w,
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: FaIcon(FontAwesomeIcons.chevronLeft, size: 25, color: Colors.white)
                      ),
                  )
                ]
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w,top: 10.h, bottom: 5.h, right: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Products", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, ),),
                Container(
                  constraints: BoxConstraints(minWidth: 60.w),
                  padding: EdgeInsets.zero,

                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        visualDensity: VisualDensity(horizontal: 0, vertical: 0),
                        backgroundColor: mainColor,
                        elevation:0,
                        shape:RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(5)
                        )
                    ),
                    onPressed: (){
                      pushNewScreen(
                        context,
                        screen: const AddEditProductPage(),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(FontAwesomeIcons.plus, size: 14, color: Colors.white),
                        SizedBox(width: 4.w,),
                        Text("Add product", style: TextStyle(color: Colors.white, fontSize: 14),)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.5),),
          ),
          Expanded(child: Consumer<ProductViewModel>(builder: (context, productViewModel, child) {
            if (productViewModel.listProductShop == null) {
              return const CircularProgressIndicator();
            }
            return GridView.builder(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
              itemCount: productViewModel.listProductShop.length,
              itemBuilder: (context, index) {
                return ProductBox(
                  product: productViewModel.listProductShop[index],
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  mainAxisExtent: 240 // height of item
              ),
            );
          })),
        ],
      ),
    );
  }
}
