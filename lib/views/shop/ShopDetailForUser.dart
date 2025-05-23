import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Shop.dart';
import 'package:dreamhome/viewmodels/ProductViewModel.dart';
import 'package:dreamhome/viewmodels/ShopViewModel.dart';
import 'package:dreamhome/views/shop/ProducBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ShopDetailForUserPage extends StatefulWidget {
  const ShopDetailForUserPage({super.key});

  @override
  State<ShopDetailForUserPage> createState() => _ShopDetailForUserPageState();
}

class _ShopDetailForUserPageState extends State<ShopDetailForUserPage> {
  late Shop shop;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProducts();
  }
  void getProducts() async {
    shop = await context.read<ShopViewModel>().shop;
    await context.read<ProductViewModel>().getAllProductByShopForUser(shop.id);
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
                        image: shopViewModel.shop!.background == null
                            ? DecorationImage(
                          image: AssetImage("assets/img_background_shop.jpg"),
                          fit: BoxFit.cover,
                        )
                            : DecorationImage(
                          image: NetworkImage('${URLImage}shop/${shopViewModel.shop!.background}'),
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
                                  child: shopViewModel.shop!.avatar == null
                                      ? Image.asset(
                                    'assets/img_shop_empty.png',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  )
                                      : Image.network(
                                    '${URLImage}shop/${shopViewModel.shop!.avatar}', // Thay thế bằng URL của ảnh
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
                                            shopViewModel.shop.name,
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(shopViewModel.shop!.totalProduct.toString() + " Products", style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      )
                                    ],
                                  )
                              ),
                            ),
                            SizedBox(width: 10.w,)
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
