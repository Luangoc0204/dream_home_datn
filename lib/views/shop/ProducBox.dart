import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Product.dart';
import 'package:dreamhome/views/shop/ProductDetail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class ProductBox extends StatelessWidget {
  Product product;
  ProductBox({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: (){
          pushNewScreen(
            context,
            screen: ProductDetail(product: this.product),
            withNavBar: false, // OPTIONAL VALUE. True by default.
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        child: Card(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))
          ),
          elevation: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 200,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  child: Image.network(
                    '${URLImage}product/${product.images[0].url}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: TextStyle(overflow: TextOverflow.ellipsis, fontSize: 16, fontWeight: FontWeight.bold), maxLines: 1,),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          if (product.discount > 0)
                            Text(
                              '\$ ${(product.price * (100 - product.discount) / 100).toStringAsFixed(2)}', // Giá sau khi giảm giá
                              style: TextStyle(color: mainColor),
                            ),
                          product.discount == 0 ? SizedBox() : SizedBox(width: 5), // Khoảng cách giữa giá giảm giá và giá gốc
                          Text(
                            '\$ ${product.price.toString()}', // Hiển thị giá gốc nếu có giảm giá
                            style: TextStyle(
                              color: product.discount == 0 ? mainColor : Colors.grey, // Màu xám cho giá gốc
                              decoration: product.discount == 0 ? null : TextDecoration.lineThrough, // Gạch chéo cho giá gốc
                            ),
                          ),
                          Spacer(),
                          Text(product.amountSold.toString() + " sold", style: TextStyle( fontSize: 10),),
                        ],
                      ),
                      Spacer(),
                      product.shop != null
                          ? Row(
                        children: [
                          FaIcon(FontAwesomeIcons.locationDot, size: 15, color: Colors.black54),
                          SizedBox(width: 5,),
                          Text(product.shop!.address, style: TextStyle(fontSize: 10, color: Colors.black54),)
                        ],
                      )
                          : Container(),
                      SizedBox(height: 7,)
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
