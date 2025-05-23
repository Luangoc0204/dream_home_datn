import 'dart:ui';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Cart.dart';
import 'package:dreamhome/models/Shop.dart';
import 'package:dreamhome/viewmodels/CartViewModel.dart';
import 'package:dreamhome/viewmodels/ChatViewModel.dart';
import 'package:dreamhome/viewmodels/ProductViewModel.dart';
import 'package:dreamhome/viewmodels/ShopViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/shop/Cart.dart';
import 'package:dreamhome/views/shop/ChattingShop.dart';
import 'package:dreamhome/views/shop/ProducBox.dart';
import 'package:dreamhome/views/shop/ProductDetail.dart';
import 'package:dreamhome/views/shop/RegisteringBusiness.dart';
import 'package:dreamhome/views/shop/ShopDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:glassmorphism/glassmorphism.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/User.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  List<CategoryShop> listCategory = CategoryShop.getCategory();
  int selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  bool isSearch = false;
  final ChatViewModel _chatViewModel = ChatViewModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllProductByType(listCategory[0].type);
    _getCart();
  }

  Future<void> _getAllProductByType(String type) async {
    await context.read<ProductViewModel>().getAllProductByType(type);
  }

  _searchProduct() async{
    String key = searchController.text.trim();
    if (key.isNotEmpty){
      await context.read<ProductViewModel>().searchProduct(key);
      setState(() {
        isSearch = true;
      });
    }
  }

  Future<void> _getCart() async {
    User user = await context.read<UserViewModel>().currentUser;
    try {
      await context.read<ShopViewModel>().getCurrentShop(user.id);
      await context.read<CartViewModel>().getCart(user.id);
    } catch (ex) {
      debugPrint("Error shopping: $ex");
    }
    Cart? cart = await context.read<CartViewModel>().cart;
    if (cart == null) {
      await context.read<CartViewModel>().addCart(Cart.noId(user));
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFFE7ECEF);
    return Scaffold(
      key: _scaffoldKey,
      drawer: const ShopNavBar(),
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const FaIcon(FontAwesomeIcons.bars, size: 20, color: Colors.black)),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Consumer<CartViewModel>(
                  builder: (context, cartViewModel, child) {
                    if (cartViewModel.cart == null || cartViewModel.cart.totalOrder == 0) {
                      return GestureDetector(
                          onTap: () {
                            pushNewScreen(
                              context,
                              screen: const CartPage(),
                              withNavBar: false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          },
                          child: Icon(Icons.shopping_bag_outlined, size: 30, color: mainColor));
                    } else if (0 < cartViewModel.cart.totalOrder && cartViewModel.cart.totalOrder <= 9)
                      return GestureDetector(
                        onTap: () {
                          pushNewScreen(
                            context,
                            screen: const CartPage(),
                            withNavBar: false, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: badges.Badge(
                          badgeContent: Text(cartViewModel.cart.totalOrder.toString(),
                              style: const TextStyle(color: Colors.white)),
                          child: Icon(Icons.shopping_bag_outlined, size: 30, color: mainColor),
                        ),
                      );
                    else
                      return GestureDetector(
                        onTap: () {
                          pushNewScreen(
                            context,
                            screen: const CartPage(),
                            withNavBar: false, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: badges.Badge(
                          badgeContent: const Text("9+", style: TextStyle(color: Colors.white)),
                          child: Icon(Icons.shopping_bag_outlined, size: 30, color: mainColor),
                        ),
                      );
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Consumer<UserViewModel>(
                builder: (BuildContext context, UserViewModel userViewModel, Widget? child) {
                  if (userViewModel.currentUser == null){
                    return FaIcon(FontAwesomeIcons.facebookMessenger, size: 30, color: mainColor);
                  }
                  return GestureDetector(
                    onTap: (){
                      pushNewScreen(
                        context,
                        screen: ChattingShopPage(currentUser: userViewModel.currentUser,),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                    child: StreamBuilder<int>(
                      stream: _chatViewModel.getUnreadConversationsCountShop(userViewModel.currentUser.id),
                      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Hiển thị một số gì đó khi đang chờ dữ liệu
                          return FaIcon(FontAwesomeIcons.facebookMessenger, size: 30, color: mainColor);
                        } else if (snapshot.hasError) {
                          // Xử lý lỗi nếu có
                          return FaIcon(FontAwesomeIcons.facebookMessenger, size: 30, color: mainColor);
                        } else {
                          if (snapshot.data == 0){
                            return FaIcon(FontAwesomeIcons.facebookMessenger, size: 30, color: mainColor);
                          }
                          // Hiển thị nội dung chính
                          return badges.Badge(
                            badgeContent: Text(
                              snapshot.data.toString(), // Hiển thị số tin nhắn chưa đọc
                              style: TextStyle(color: Colors.white),
                            ),
                            child: FaIcon(FontAwesomeIcons.facebookMessenger, size: 30, color: mainColor),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                width: 20,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(blurRadius: 10, offset: -const Offset(3, 3), spreadRadius: 1, color: Colors.white),
                        BoxShadow(
                            blurRadius: 10,
                            offset: const Offset(3, 3),
                            spreadRadius: 1,
                            color: const Color(0xffa7a9af).withOpacity(0.7)),
                      ],
                    ),
                    child: TextFormField(
                      controller: searchController,
                      style: TextStyle(color: mainColor),
                      onEditingComplete: () {
                        // Thực hiện hàm search ở đây khi nhấn enter trên bàn phím
                        _searchProduct();
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(15.0),
                        filled: true,
                        fillColor: const Color(0xfff1f1f1),
                        hintText: 'Search...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            // Thực hiện hàm search ở đây khi nhấn icon search
                            _searchProduct();
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent, width: 0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: mainColor, width: 1.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          isSearch
              ? Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: IconButton(onPressed: (){
                        setState(() {
                          isSearch = false;
                        });
                      }, icon: FaIcon(FontAwesomeIcons.arrowLeft, size: 30, color: mainColor)),
                    ),
                    Expanded(child: Consumer<ProductViewModel>(builder: (context, productViewModel, child) {
                        if (productViewModel.listProductSearch == null) {
                          return Center(child: Text("No products match", style: TextStyle(color: Colors.grey),),);
                        } else {
                          return GridView.builder(
                            padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                            itemCount: productViewModel.listProductSearch.length,
                            itemBuilder: (context, index) {
                              return ProductBox(
                                product: productViewModel.listProductSearch[index],
                              );
                            },
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                mainAxisExtent: 250 // height of item
                                ),
                          );
                        }
                      })),
                  ],
                ),
              )
              : Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 90,
                        color: Colors.transparent,
                        padding: const EdgeInsets.only(top: 0),
                        child: ListView.builder(
                            padding: const EdgeInsets.all(5),
                            scrollDirection: Axis.horizontal,
                            itemCount: listCategory.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedIndex = index; // Lưu trạng thái chọn
                                    });
                                    _getAllProductByType(listCategory[index].type);
                                  },
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.all(0),
                                  highlightColor: Colors.transparent,
                                  // Đặt màu trong trạng thái highlight
                                  splashColor: Colors.transparent,
                                  icon: Container(
                                    width: 60,
                                    height: 60,
                                    padding: const EdgeInsets.all(13.0),
                                    // Điều chỉnh khoảng cách nội dung với mép container
                                    decoration: BoxDecoration(
                                      gradient: index == selectedIndex
                                          ? LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                const Color(0xFF3D3955),
                                                const Color(0xFF524D6C).withOpacity(0.9),
                                                const Color(0xFF35314C)
                                              ],
                                            )
                                          : LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                const Color(0xFFffffff),
                                                const Color(0xFFf1f1f1).withOpacity(0.9),
                                                const Color(0xFFffffff)
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(15.0), // Điều chỉnh độ cong của góc container
                                      color: backgroundColor,
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 10,
                                            offset: -const Offset(3, 3),
                                            spreadRadius: 1,
                                            color: Colors.white),
                                        BoxShadow(
                                            blurRadius: 10,
                                            offset: const Offset(3, 3),
                                            spreadRadius: 1,
                                            color: const Color(0xffa7a9af).withOpacity(0.7)),
                                      ],
                                    ),
                                    child: Center(
                                      child: ShaderMask(
                                          shaderCallback: (Rect bounds) {
                                            return index == selectedIndex
                                                ? const LinearGradient(
                                                    colors: [
                                                      Color(0xFFFFF400),
                                                      Color(0xFFFFE702),
                                                      Color(0xFFFFCE00),
                                                      Color(0xFFFDBF00),
                                                      Color(0xFFFFF400),
                                                    ],
                                                  ).createShader(bounds)
                                                : const LinearGradient(
                                                    colors: [Color(0xFF3D3955), Color(0xFF3D3955)],
                                                  ).createShader(bounds);
                                          },
                                          child: listCategory[index].icon),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      Expanded(child: Consumer<ProductViewModel>(builder: (context, productViewModel, child) {
                        if (productViewModel.listProduct == null) {
                          return const CircularProgressIndicator();
                        } else {
                          return GridView.builder(
                            padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                            itemCount: productViewModel.listProduct.length,
                            itemBuilder: (context, index) {
                              return ProductBox(
                                product: productViewModel.listProduct[index],
                              );
                            },
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                mainAxisExtent: 250 // height of item
                                ),
                          );
                        }
                      })),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class CategoryShop {
  Widget icon;
  String type;
  String typeText;

  CategoryShop(this.icon, this.type, this.typeText);

  static List<CategoryShop> getCategory() {
    List<CategoryShop> list = [];
    list.add(CategoryShop(const FaIcon(FontAwesomeIcons.chair, size: 25, color: Colors.white), 'chair', "Chair"));
    list.add(CategoryShop(const FaIcon(FontAwesomeIcons.couch, size: 25, color: Colors.white), 'couch', "Couch"));
    list.add(CategoryShop(
        const Icon(
          Icons.light,
          size: 25,
          color: Colors.white,
        ),
        'light',
        "Light"));
    list.add(CategoryShop(
        const Icon(
          Icons.table_bar,
          size: 25,
          color: Colors.white,
        ),
        'table_bar',
        "Table bar"));
    list.add(CategoryShop(
        const Icon(
          Icons.table_restaurant,
          size: 25,
          color: Colors.white,
        ),
        'table_restaurant',
        "Table restaurant"));
    list.add(CategoryShop(const FaIcon(FontAwesomeIcons.bath, size: 25, color: Colors.white), 'bath', "Bath"));
    list.add(CategoryShop(const FaIcon(FontAwesomeIcons.sink, size: 25, color: Colors.white), 'sink', "Sink"));
    list.add(CategoryShop(const FaIcon(FontAwesomeIcons.shower, size: 25, color: Colors.white), 'shower', "Shower"));
    list.add(CategoryShop(const FaIcon(FontAwesomeIcons.bed, size: 25, color: Colors.white), 'bed', "Bed"));
    return list;
  }
}

class ShopNavBar extends StatefulWidget {
  const ShopNavBar({super.key});

  @override
  State<ShopNavBar> createState() => _ShopNavBarState();
}

class _ShopNavBarState extends State<ShopNavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<ShopViewModel>(
        builder: (context, shopViewModel, child) {
          return Column(
            children: [
              Container(
                  child: Stack(children: [
                Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    image: shopViewModel.currentShop == null || shopViewModel.currentShop!.background == null
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 10.w,
                          ),
                          child: ClipOval(
                              child: shopViewModel.currentShop == null || shopViewModel.currentShop!.avatar == null
                                  ? Image.asset(
                                      'assets/img_shop_empty.png',
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      '${URLImage}shop/${shopViewModel.currentShop!.avatar}',
                                      // Thay thế bằng URL của ảnh
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )),
                        ),
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(left: 10.w, right: 20.w),
                              child: Text(
                                shopViewModel.currentShop == null
                                    ? "You have not \n registered your \n business"
                                    : shopViewModel.currentShop.name,
                                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ])),
              Consumer<ShopViewModel>(
                builder: (BuildContext context, ShopViewModel shopViewModel, Widget? child) {
                  if (shopViewModel.currentShop != null) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          pushNewScreen(
                            context,
                            screen: const ShopDetailPage(),
                            withNavBar: false, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: const Text(
                          "My Shop",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          pushNewScreen(
                            context,
                            screen: const RegisteringBusinessPage(),
                            withNavBar: false, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: const Text(
                          "Business Registration",
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
