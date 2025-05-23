import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Cart.dart';
import 'package:dreamhome/models/Order.dart';
import 'package:dreamhome/models/Product.dart';
import 'package:dreamhome/models/Review.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/CartViewModel.dart';
import 'package:dreamhome/viewmodels/OrderViewModel.dart';
import 'package:dreamhome/viewmodels/ProductViewModel.dart';
import 'package:dreamhome/viewmodels/ReviewViewModel.dart';
import 'package:dreamhome/viewmodels/ShopViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/shop/AllReviewForProduct.dart';
import 'package:dreamhome/views/shop/Cart.dart';
import 'package:dreamhome/views/shop/DetailChatShop.dart';
import 'package:dreamhome/views/shop/ShopDetailForUser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:hexcolor/hexcolor.dart';
import 'package:icon_decoration/icon_decoration.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/zondicons.dart';
class ProductDetail extends StatefulWidget {
  Product product;
  ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState(this.product);
}

class _ProductDetailState extends State<ProductDetail> {
  SwiperController swiperController = SwiperController();
  Product product;
  _ProductDetailState(this.product);
  int chooseProductAddToCart = 0;
  int quantity = 1;

  User? currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
    _getTotalReview();
    _getCurrentUser();
  }
  void _getCurrentUser() async {
    currentUser = await context.read<UserViewModel>().currentUser;
  }
  _getTotalReview() async {
    await context.read<ReviewViewModel>().getTotalReviewsForProduct(product.id);
  }
  Future<void> getProduct() async {
    await context.read<ProductViewModel>().getProduct(this.product.id);
    Product? productApi = await context.read<ProductViewModel>().product!;
    if (productApi!.id == this.product.id){
      setState(() {
        this.product = productApi;
        print("Product Api:" + productApi.toString());
      });
    }
  }
  // late final Review review = Review("avc",
  //     "Shop giao hàng nhanh, đóng gói cẩn thận. Hàng có tem chứng nhận hàng giả đầy đủ", 5, Product(), User("abc", "Nguyễn Thành Luân", "ntluangoc@gmail.com", null), DateTime.now(), DateTime.now());
  int selectedColor = -1;
  int selectedImage = 0;
  Widget showImageWithColor(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: this.product.images.length == 1 ?
              Image.network('${URLImage}product/${product.images[0].url}', fit: BoxFit.contain,)
            : Swiper(
              controller: swiperController,
              indicatorLayout: PageIndicatorLayout.COLOR,
              itemCount: product.images.length,
              pagination: const SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                    color: Color(0xFFFDE4D4),
                    activeColor: Color(0xFFFF822C)
                ),

                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.all(10),

              ),
              control: const SwiperControl(
                  color: Color(0xFFFF822C)
              ),
              onIndexChanged: (index) {
                if (product.images[index].colorName != null){
                  setState(() {
                    selectedColor = index;
                  });
                } else {
                  setState(() {
                    selectedColor = -1;
                  });
                }
              },
              itemBuilder: (context, index) {
                return Container(
                  child: Center(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: Image.network('${URLImage}product/${product.images[index].url}', fit: BoxFit.contain,)
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        this.product.images.length == 0 ? SizedBox(height: 10,)
        : Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Container(
              width: 250,
              height: 80,
              child: Center(
                child: this.product.images.length == 1 ? Icon(FontAwesomeIcons.solidCircle, size: 30, color: HexColor(product.images[0].colorCode!))
                 : ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: product.images.length,
                    itemBuilder: (context, index) {
                      if (product.images[index].colorName == null){
                        return const SizedBox();
                      }
                      else {
                        Color color = HexColor(product.images[index].colorCode!);
                        return Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    selectedColor = index;
                                    swiperController.move(index);

                                  });
                                },
                                highlightColor: Colors.transparent, // Đặt màu trong trạng thái highlight
                                splashColor: Colors.transparent,
                                icon: index == selectedColor ? Padding(
                                  padding: const EdgeInsets.only(bottom: 13.0),
                                  child: DecoratedIcon(
                                    icon: Icon(FontAwesomeIcons.droplet, size: 40, color: color),
                                    decoration: IconDecoration(
                                        border: IconBorder(
                                            width: 1,
                                            color: mainColor
                                        )
                                    ),
                                  ),
                                ): Icon(FontAwesomeIcons.solidCircle, size: 30, color: color)
                            )
                        );
                      }
                    }
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top,),
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: FaIcon(FontAwesomeIcons.chevronLeft, size: 25, color: Colors.black)
                  ),
                  SizedBox(width: 10,),
                  Text("Product", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10,right: 10),
                    child: Consumer<CartViewModel>(
                      builder: (context, cartViewModel, child){
                        return GestureDetector(
                          onTap: (){
                            pushNewScreen(
                              context,
                              screen: const CartPage(),
                              withNavBar: false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          },
                          child: badges.Badge(
                            badgeContent: Text(cartViewModel.cart!.totalOrder.toString(), style: TextStyle(color: Colors.white)),
                            child: Icon(Icons.shopping_bag_outlined, size: 30, color: mainColor),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ),
          SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.5),
              thickness: 1,
            ),
          ),
          Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 0),
                children: [
                  showImageWithColor(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, )),
                        Text("\$ " + product.price.toString(), style: TextStyle(color: mainColor,fontSize: 20, fontWeight: FontWeight.w600), ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            showRating(),
                            Text(product.amountSold.toString() + " Sold", style: TextStyle(fontSize: 18),),
                          ],
                        ),
                        SizedBox(height: 10,),


                      ],
                    ),
                  ),
                  Divider(thickness: 8, height: 8, color: Colors.grey.withOpacity(0.2),),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipOval(
                                child: product.shop == null || product.shop!.avatar == null  ? Image.asset(
                                  'assets/img_shop_empty.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ) : Image.network(
                                  '${URLImage}shop/${product.shop!.avatar}', // Thay thế bằng URL của ảnh
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (product.shop != null){
                                      await context.read<ShopViewModel>().getShop(product.shop!.id);
                                      pushNewScreen(
                                        context,
                                        screen: ShopDetailForUserPage(),
                                        withNavBar: false, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      );
                                    }
                                  },
                                  child: Container(
                                      width: 200,
                                      child: Text(product.shop == null ? "" : product.shop!.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20), )
                                  ),
                                ),
                                Row(
                                  children: [
                                    FaIcon(FontAwesomeIcons.locationDot, size: 15, color: Colors.black54),
                                    SizedBox(width: 5,),
                                    Text(product.shop == null ? "" : product.shop!.address, style: TextStyle(fontSize: 10, color: Colors.black54),)
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Text(product.shop == null ? "" : product.shop!.totalProduct.toString(), style: TextStyle(color: mainColor, fontSize: 16),),
                            Text(" Products", style: TextStyle(fontSize: 16),),
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(thickness: 8, height: 8, color: Colors.grey.withOpacity(0.2),),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                        SizedBox(height: 10,),
                        Text(product.content, style: TextStyle(fontSize: 20),)
                      ],
                    ),
                  ),
                  Divider(thickness: 8, height: 8, color: Colors.grey.withOpacity(0.2),),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Product Ratings", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    showRatingReview(product.totalRating),
                                    SizedBox(width: 5,),
                                    Text(product.totalRating.toString(), style: TextStyle(fontSize: 16),),
                                    SizedBox(width: 5,),
                                    Consumer<ReviewViewModel>(
                                        builder: (BuildContext context, ReviewViewModel reviewViewModel, Widget? child) {
                                          if (reviewViewModel.totalReview == 0){
                                            return Text("(0 reviews)", style: TextStyle(fontSize: 16),);
                                          }
                                          return Text("(${reviewViewModel.totalReview} reviews)", style: TextStyle(fontSize: 16),);
                                        },)
                                  ],
                                ),

                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                    onTap:(){
                                      pushNewScreen(
                                        context,
                                        screen: AllReviewForProduct(product: product),
                                        withNavBar: false, // OPTIONAL VALUE. True by default.
                                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                      );
                                    },
                                    child: Text("See all", style: TextStyle(fontSize: 24, color: mainColor),)
                                ),
                                Icon(FontAwesomeIcons.chevronRight, size: 20, color: mainColor,)
                              ],
                            )
                          ],
                        ),
                        Divider(thickness: 1, height: 1, color: Colors.grey.withOpacity(0.2),),
                        ReviewItem(product: product,)
                      ],
                    ),

                  ),


                ],
              )
          ),
          Container(
            height: 65,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: mainColor,
                  width: 1
                )
              )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      if (product.shop != null && currentUser != null){
                        pushNewScreen(
                          context,
                          screen: DetailChatShopPage(receiverUserName: product.shop!.name, receiverUserId: product.shop!.id, receiverUserAvatar: product.shop!.avatar, senderUserName: currentUser!.name, senderUserId: currentUser!.id, senderUserAvatar: currentUser!.avatar, currentUserId: currentUser!.id,),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.commentDots, size: 20, color: mainColor,),
                        SizedBox(height: 5,),
                        Text("Chat Now")
                      ],
                    ),
                  ),
                ),
                Container(
                    height: 35,
                    child: VerticalDivider(width: 1, color: Colors.grey, thickness: 1, )
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      showOrderBox();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_shopping_cart, size: 20, color: mainColor,),
                        SizedBox(height: 5,),
                        Text("Add to Cart")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget showRating(){
    return Row(
      children: [Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFF400), Color(0xFFFFE702), Color(0xFFFFCE00), Color(0xFFFDBF00),Color(0xFFFFF400),],
              ).createShader(bounds);
            },
            child: Icon(FontAwesomeIcons.solidStar, size: 20, color: Colors.white,)
        ),
      ),
        SizedBox(width: 5,),
        Text(product.totalRating.toString() + " / 5", style: TextStyle(fontSize: 18),),
        SizedBox(width: 10,),
        Container(
            height: 15,
            child: VerticalDivider(width: 1, color: Colors.grey, thickness: 1, )
        ),
        SizedBox(width: 10,),

      ],
    );
  }
  Widget showRatingReview(num totalRating) {
    int fullStars = totalRating.floor();
    bool hasHalfStar = totalRating - fullStars > 0.0;

    List<Widget> stars = List.generate(5, (index) {
      if (index < fullStars) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:2.0),
          child: Icon(FontAwesomeIcons.solidStar, color: Colors.yellow, size: 16,),
        );
      } else if (hasHalfStar && index == fullStars) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:2.0),
          child: Icon(FontAwesomeIcons.starHalfStroke, color: Colors.yellow, size: 16,),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:2.0),
          child: Icon(FontAwesomeIcons.star, color: Colors.yellow, size: 16,),
        );
      }
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: stars,
      ),
    );
  }
  Widget makeDismissible({required Widget child,required BuildContext context}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: ()=> Navigator.pop(context),
    child: GestureDetector(onTap: (){}, child: child,),
  );
  showOrderBox() {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        useRootNavigator: true,
        builder: (context) {
          return makeDismissible(
              context: context,
              child: StatefulBuilder(
                  builder: (context, setNewState) {
                    return DraggableScrollableSheet(
                        initialChildSize: 0.6,
                        minChildSize: 0.5,
                        maxChildSize: 0.9,
                        builder: (_, controller) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)
                            ),
                            color: Color(0xFFfbfbfb),

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: mainColor,  // Màu đường viền
                                              width: 1,              // Độ rộng của đường viền
                                            ),
                                          ),
                                          child: Image.network('${URLImage}product/${product.images[chooseProductAddToCart].url}', fit: BoxFit.contain, width: 150, height: 150,)
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("\$ ${product.price}", style: TextStyle(fontSize: 25, color: mainColor, fontWeight: FontWeight.bold),),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                        },
                                        icon: FaIcon(FontAwesomeIcons.xmark, size: 25, color: Colors.grey),
                                      )
                                    ],
                                  ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0, bottom: 20),
                                child: Text("Color:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Wrap(
                                  children: product.images.asMap().entries.map((entry) {
                                    if (entry.value.colorName == null) {
                                      return const SizedBox();
                                    }
                                    else {
                                      int index = entry.key;
                                      Color colorItem = HexColor(entry.value.colorCode!);
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Xử lý sự kiện khi nút được nhấn
                                            setNewState(() {
                                              chooseProductAddToCart = index;
                                            });
                                          },
                                          child: FittedBox(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: chooseProductAddToCart == index ? mainColor : Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: chooseProductAddToCart == index ? mainColor : colorItem
                                                  )
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 15),
                                                  child: Text(entry.value.colorName!, style: TextStyle(color: chooseProductAddToCart == index ? Colors.white : Colors.black),),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }).toList(),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0, right: 30),
                                    child: Text("Quantity:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20), textAlign: TextAlign.center,),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setNewState(() {
                                        if(quantity > 1) quantity = quantity - 1;
                                      });
                                    },
                                    child: Container(
                                      width: 30,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: mainColor,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                        ),
                                      ),
                                      child: Center(child: Text("-", style: TextStyle(fontSize: 20),)),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: mainColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(quantity.toString(), style: TextStyle(fontSize: 20),),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setNewState(() {
                                        quantity = quantity + 1;
                                      });
                                    },
                                    child: Container(
                                      width: 30,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: mainColor,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                      ),
                                      child: Center(child: Text("+", style: TextStyle(fontSize: 20),)),
                                    ),
                                  ),
                                ],
                              ),

                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Xử lý sự kiện khi nút được nhấn
                                    addToCart();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Đặt giá trị radius theo mong muốn
                                    ),
                                    minimumSize: Size(MediaQuery.of(context).size.width, 40), // Kích thước tối thiểu của mỗi button
                                  ),
                                  child: Text('Add to Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                ),
                              )
                            ],
                          ),


                        )
                    );
                  }
              )
          );
        }
    );
  }
  addToCart() async {
    Cart cart = await context.read<CartViewModel>().cart;
    Order order = Order.noId(product, quantity, product.images[chooseProductAddToCart], cart);
    // print(order.toString());
    await context.read<OrderViewModel>().addOrder(order);
    User user = await context.read<UserViewModel>().currentUser;
    await context.read<CartViewModel>().getCart(user.id);
    FlutterToastr.show("Order successfully", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
  }
}
class ReviewItem extends StatefulWidget {
  ReviewItem({super.key, required this.product});
  final Product product;
  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  @override
  void initState() {
    super.initState();
    _getListReview();
  }
  _getListReview() async{
    await context.read<ReviewViewModel>().getAllReviewForProduct(widget.product.id, 3);
  }
  Widget showRatingReview(num rating) {
    List<Widget> stars = List.generate(5, (index) {
      if (index <= rating-1) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:2.0),
          child: Icon(FontAwesomeIcons.solidStar, color: Colors.yellow, size: 14,),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:2.0),
          child: Icon(FontAwesomeIcons.star, color: Colors.yellow, size: 14,),
        );
      }
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: stars,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewViewModel>(
      builder: (BuildContext context, ReviewViewModel reviewViewModel, Widget? child) {
        if (reviewViewModel.listReview.isEmpty){
          return SizedBox();
        }
        return ListView.builder(
          reverse: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: reviewViewModel.listReview.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ClipOval(
                        child: reviewViewModel.listReview[index].author.avatar == null
                            ? Image.asset(
                          'assets/img_avatar_empty.jpg',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        )
                            : Image.network(
                          '${URLImage}user/${reviewViewModel.listReview[index].author.avatar}',
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(reviewViewModel.listReview[index].author.name, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
                          Row(
                            children: [
                              Text(reviewViewModel.listReview[index].order.color.colorName),
                              Padding(
                                padding: const EdgeInsets.only(top: 3.0, left: 5),
                                child: showRatingReview(reviewViewModel.listReview[index].rating),
                              )
                            ],
                          ),
                          Container(
                              width: 280.w,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(reviewViewModel.listReview[index].content, style: TextStyle(fontSize: 16),),
                              )
                          )
                        ],
                      ),
                    )
                  ],
                )
            );
          },
        );
      },
    );
  }

}

