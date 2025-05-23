import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Cart.dart';
import 'package:dreamhome/models/Order.dart';
import 'package:dreamhome/viewmodels/CartViewModel.dart';
import 'package:dreamhome/viewmodels/OrderViewModel.dart';
import 'package:dreamhome/views/shop/Purchase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  ListItemCart listItemCart = ListItemCart([]);
  bool isCheckAll = false;
  num totalPrice = 0;
  List<Order> listOrderPurchase = [];
  
  @override
  void initState() {
    super.initState();
    _getListOrder();
  }

  _getListOrder() async {
    Cart cart = await context.read<CartViewModel>().cart;
    await context.read<OrderViewModel>().getAllByCart(cart.id);
    await context.read<CartViewModel>().getCart(cart.author.id);
    List<Order> listOrder = await context.read<OrderViewModel>().listOrder;
    setState(() {
      listItemCart = ListItemCart(listOrder);
    });
  }
  _updateAmountOrder(Order order) async{
    await context.read<OrderViewModel>().updateAmountOrder(order);
    FlutterToastr.show("Update amount order successfully", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
    _getListOrder();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
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
                    "Cart",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  Consumer<CartViewModel>(builder: (context, cartViewModel, child) {
                    return Text(
                      " (" + cartViewModel.cart.totalOrder.toString() + ")",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                    );
                  }),
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
              child: Container(
                color: Color(0xFFF8F9FB),
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    itemCount: listItemCart.listOrder.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              // border: Border(bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.5)))
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: Transform.scale(
                                  scale: 1.5, // Thay đổi tỉ lệ theo nhu cầu
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: mainColor,
                                    side: BorderSide(color: mainColor),
                                    value: listItemCart.listCheck[index],
                                    onChanged: (newValue) {
                                      setState(() {
                                        listItemCart.listCheck[index] = newValue!;
                                        listItemCart.updateTotalPrice();
                                        isCheckAll = listItemCart.listCheck.every((element) => element == true);
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(border: Border.all(color: mainColor, width: 1)),
                                child: Image.network('${URLImage}product/${listItemCart.listOrder[index].color.url}')
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: 200.w,
                                      child: Text(
                                        listItemCart.listOrder[index].product!.name,
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                  ),
                                  SizedBox(height: 5.h,),
                                  Row(
                                    children: [
                                      if (listItemCart.listOrder[index].product!.discount > 0)
                                        Text(
                                          '\$ ${(listItemCart.listOrder[index].product!.price * (100 - listItemCart.listOrder[index].product!.discount) / 100).toStringAsFixed(2)}', // Giá sau khi giảm giá
                                          style: TextStyle(color: mainColor, fontSize: 16),
                                        ),
                                      listItemCart.listOrder[index].product!.discount == 0 ? SizedBox() : SizedBox(width: 5),
                                      Text(
                                        '\$ ${listItemCart.listOrder[index].product!.price.toString()}', // Hiển thị giá gốc nếu có giảm giá
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: listItemCart.listOrder[index].product!.discount == 0 ? mainColor : Colors.grey, // Màu xám cho giá gốc
                                          decoration: listItemCart.listOrder[index].product!.discount == 0 ? null : TextDecoration.lineThrough, // Gạch chéo cho giá gốc
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h,),
                                  Container(
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showOrderBox(listItemCart.listOrder[index]);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                                        elevation: 0,
                                        backgroundColor: Color(0xFFF1F3F6),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Color: " +
                                                listItemCart.listOrder[index].color.colorName! +
                                                " | Amount: " +
                                                listItemCart.listOrder[index].amount.toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          const FaIcon(FontAwesomeIcons.chevronDown, size: 12, color: Color(0xFF42424D))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              )
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: Colors.grey.withOpacity(0.5)
                )
              )
            ),
            constraints: BoxConstraints(
              minHeight: 50.h
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Transform.scale(
                    scale: 1.5, // Thay đổi tỉ lệ theo nhu cầu
                    child: Checkbox(
                      checkColor: Colors.white,
                      activeColor: mainColor,
                      side: BorderSide(color: mainColor),
                      value: isCheckAll,
                      onChanged: (newValue) {
                        setState(() {
                          isCheckAll = newValue!;
                          listItemCart.checkAll(newValue);
                          listItemCart.updateTotalPrice();
                        });
                      },
                    ),
                  ),
                ),
                Spacer(),
                Text("\$ " + listItemCart.totalPrice.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(width: 20.w,),
                GestureDetector(
                  onTap: (){
                    listOrderPurchase.clear();
                    for (int i=0; i<listItemCart.listOrder.length; i++){
                      if (listItemCart.listCheck[i]){
                        listOrderPurchase.add(listItemCart.listOrder[i]);
                      }
                    }
                    pushNewScreen(
                      context,
                      screen: PurchasePage(listOrder: listOrderPurchase, totalPrice: listItemCart.totalPrice),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    color: mainColor,
                    height: 50.h,
                    child: Center(
                      child: Text("Check out", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget makeDismissible({required Widget child,required BuildContext context}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: ()=> Navigator.pop(context),
    child: GestureDetector(onTap: (){}, child: child,),
  );
  showOrderBox(Order order) {
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
                                        child: Image.network('${URLImage}product/${order.color.url}', fit: BoxFit.contain, width: 150, height: 150,)
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("\$ ${order.product!.price}", style: TextStyle(fontSize: 25, color: mainColor, fontWeight: FontWeight.bold),),
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
                                child: Row(
                                  children: [
                                    Text("Color:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                    SizedBox(width: 10,),
                                    Text(order.color.colorName!, style: TextStyle( fontSize: 20),),
                                  ],
                                ),
                              ),
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
                                        if(order.amount! > 1) order.amount = order.amount! - 1;
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
                                    child: Text(order.amount!.toString(), style: TextStyle(fontSize: 20),),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setNewState(() {
                                        order.amount = order.amount! + 1;
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
                                    _updateAmountOrder(order);
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0), // Đặt giá trị radius theo mong muốn
                                    ),
                                    minimumSize: Size(MediaQuery.of(context).size.width, 40), // Kích thước tối thiểu của mỗi button
                                  ),
                                  child: Text('Update', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
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
}

class ListItemCart {
  List<bool> listCheck;
  List<Order> listOrder;
  num totalPrice = 0;

  ListItemCart(this.listOrder) : listCheck = List.generate(listOrder.length, (index) => false);
  void checkAll(bool isChecked) {
    for (int i = 0; i < listCheck.length; i++) {
      listCheck[i] = isChecked;
    }
  }
  void updateTotalPrice() {
    totalPrice = 0;
    for (int i = 0; i < listOrder.length; i++) {
      if (listCheck[i]) {
        num priceFinal = listOrder[i].product!.price - listOrder[i].product!.price * listOrder[i].product!.discount / 100;
        print("discount: " + listOrder[i].product!.discount.toString());
        print("discount price: " + (listOrder[i].product!.price * listOrder[i].product!.discount).toString());
        print("price final: $priceFinal");
        totalPrice += priceFinal;
      }
    }
  }
}
