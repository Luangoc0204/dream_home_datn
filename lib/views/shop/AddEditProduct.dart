import 'dart:io';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/data/color.dart';
import 'package:dreamhome/models/Product.dart';
import 'package:dreamhome/models/Shop.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/viewmodels/ProductViewModel.dart';
import 'package:dreamhome/viewmodels/ShopViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/shop/Shopping.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconify_flutter_plus/icons/akar_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class AddEditProductPage extends StatefulWidget {
  const AddEditProductPage({super.key});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final ImagePicker imagePicker = ImagePicker();
  List<ImageColorProduct> listImageColor = [];
  List<XFile> imageFileList = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Color? _selectedColor;
  late String selectedType;
  List<CategoryShop> listType = CategoryShop.getCategory();
  CategoryShop? selectedCategory;
  late User user;

  void selectImage() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages != null && selectedImages.isNotEmpty) {
      setState(() {
        for (XFile image in selectedImages) {
          ImageColorProduct imageColorProduct = ImageColorProduct(image, "", null);
          listImageColor.add(imageColorProduct); // Thêm đối tượng ImageColorProduct vào danh sách
        }
      });
    }
    print(listImageColor.toString());
  }
  Future<void> addProduct() async {
    String name = nameController.text.trim();
    num price = num.parse(priceController.text.trim());
    int discount = discountController.text.trim().isEmpty ? 0 : int.parse(discountController.text.trim());
    String description = descriptionController.text.trim();
    List<File> images = [];
    for (var imageColorProduct in listImageColor) {
      images.add(File(imageColorProduct.image.path));
    }
    if (name=="") FlutterToastr.show("Name is empty!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
    else {
      user = await context.read<UserViewModel>().currentUser!;
      Shop shop = await context.read<ShopViewModel>().currentShop;
      showAlertDialog(context);
      List<ProductImage> listProductImageAdd = [];
      for (var product in listImageColor) {
        listProductImageAdd.add(
          ProductImage(
            id: null,
            url: "",
            colorName: product.colorName!.trim() == "" ? null : product.colorName!.trim(),
            colorCode: product.colorCode == null ? null : convertColorToHex(product.colorCode!), // Chuyển Color thành String
          ),
        );
      }
      Product product = Product.noId(name, price, discount, selectedType, description, shop);
      await context.read<ProductViewModel>().addProductWithImages(product, images, listProductImageAdd);
      Product? productResponse = await context.read<ProductViewModel>().product;
      await context.read<ProductViewModel>().getAllProductByShop(shop.id);
      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
      if (productResponse!.id == '')  FlutterToastr.show("Failed!", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
      else {
        if (productResponse.id == '')  FlutterToastr.show("Your product has been created", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
        Navigator.of(context).pop();

      }
    }
  }
  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
        content: Container(
          child: Lottie.asset("assets/lottie/loading_hand.json"),
        )
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top,),
            Row(
              children: [
                IconButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.arrowLeft,
                    size: 15,
                    color: Colors.black,
                  ),
                ),
                Text("Create product", style: TextStyle(fontSize: 20),),
                Spacer(),
                ElevatedButton(
                  onPressed: (){
                    addProduct();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                      shadowColor: MaterialStateProperty.all(Colors.transparent),
                      foregroundColor: MaterialStateProperty.all(Colors.transparent),
                      overlayColor: MaterialStateProperty.all(Colors.red)
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFF512F), Color.fromRGBO(244, 92, 67, 0.5169), Color(0xFFFF512F)], // Màu gradient từ dưới lên trên
                        ),
                        borderRadius: BorderRadius.circular(10.0), // Bo tròn góc của nút
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Create',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5,),
            Divider(height: 1, color: Colors.grey.withOpacity(0.5), thickness: 1,),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 10, left: 5, right: 5),
                children: [
                  SizedBox(height: 10.h,),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(decoration: TextDecoration.none),
                      children: <TextSpan>[
                        TextSpan(text: '* ', style: TextStyle(color: mainColor, fontSize: 18)),
                        const TextSpan(text: "Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  TextField(
                    controller: nameController,
                    maxLength: 50,
                    decoration: InputDecoration(
                      hintText: "Name ...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(decoration: TextDecoration.none), // Thêm decoration: TextDecoration.none
                      children: <TextSpan>[
                        TextSpan(text: '* ', style: TextStyle(color: mainColor, fontSize: 18)),
                        const TextSpan(text: "Price", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      hintText: "Price ...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true), // Đặt kiểu bàn phím là số thập phân
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')), // Chỉ cho phép nhập số thập phân có tối đa 2 chữ số sau dấu phẩy
                      FilteringTextInputFormatter.deny(RegExp(r'^0+(?!$)')), // Loại bỏ các số 0 dư thừa ở đầu
                      FilteringTextInputFormatter.deny(RegExp(r'^\.{2,}')), // Loại bỏ trường hợp nhập nhiều hơn một dấu chấm

                    ],
                  ),
                  SizedBox(height: 10.h,),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(decoration: TextDecoration.none), // Thêm decoration: TextDecoration.none
                      children: <TextSpan>[
                        TextSpan(text: '* ', style: TextStyle(color: mainColor, fontSize: 18)),
                        const TextSpan(text: "Type", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  DropdownButtonFormField2<CategoryShop>(
                    isExpanded: true,
                    value: selectedCategory,
                    decoration: InputDecoration(
                      // Add Horizontal padding using menuItemStyleData.padding so it matches
                      // the menu padding when button's width is not specified.
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // Add more decoration..
                    ),
                    hint: const Text(
                      'Select Type',
                      style: TextStyle(fontSize: 16),
                    ),
                    items: listType
                        .map((item) => DropdownMenuItem<CategoryShop>(
                      value: item,
                      child: Row(
                        children: [
                          ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return  const LinearGradient(
                                  colors: [
                                    Color(0xFFFFF400),
                                    Color(0xFFFFE702),
                                    Color(0xFFFFCE00),
                                    Color(0xFFFDBF00),
                                    Color(0xFFFFF400),
                                  ],
                                ).createShader(bounds);
                              },
                              child: item.icon),
                          SizedBox(width: 5.w,),
                          Text(
                            item.typeText,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select type.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      //Do something when selected item is changed.
                      setState(() {
                        selectedCategory = value; // Cập nhật giá trị được chọn
                        selectedType = value!.type;
                      });
                    },
                    onSaved: (value) {
                      selectedType = value!.type;
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.only(right: 8),
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  Text("    Discount (%)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(height: 10.h,),
                  TextField(
                    controller: discountController,
                    decoration: InputDecoration(
                      hintText: "Discount ...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    keyboardType: TextInputType.number, // Đặt kiểu bàn phím là số
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^[1-9]\d*')), // Chỉ cho phép nhập số nguyên dương
                    ],
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        final intValue = int.tryParse(value);
                        if (intValue == null || intValue < 0 || intValue >= 100) {
                          // Nếu giá trị nhập vào không phải là số nguyên dương hoặc nằm ngoài phạm vi cho phép
                          // ở đây bạn có thể hiển thị một thông báo hoặc thực hiện hành động phù hợp
                          FlutterToastr.show("Discount must be higher than 0 and lower than 100", context, duration: FlutterToastr.lengthLong, position:  FlutterToastr.bottom);
                          discountController.text = '100'; // Xóa giá trị không hợp lệ
                        }
                      }
                    },
                  ),
                  SizedBox(height: 10.h,),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(decoration: TextDecoration.none), // Thêm decoration: TextDecoration.none
                      children: <TextSpan>[
                        TextSpan(text: '* ', style: TextStyle(color: mainColor, fontSize: 18)),
                        const TextSpan(text: "Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: "Description ...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(decoration: TextDecoration.none), // Thêm decoration: TextDecoration.none
                      children: <TextSpan>[
                        TextSpan(text: '* ', style: TextStyle(color: mainColor, fontSize: 18)),
                        const TextSpan(text: "Image", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                        const TextSpan(text: " (Please only add one color to the image of a corresponding product)", style: TextStyle(fontSize: 12, color: Colors.black)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  listImageColor.isNotEmpty ?
                  ListView.builder(
                    padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    itemCount: listImageColor.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.grey
                                ),
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 150.h,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey
                                      ),
                                      borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: Image.file(File(listImageColor[index].image.path), fit: BoxFit.contain,),
                                ),
                                SizedBox(height: 10.h,),
                                Row(
                                  children: [
                                    Text("Color name:", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(width: 10.w,),
                                    Expanded(
                                      child: TextField(
                                        controller: listImageColor[index].controller,
                                        onChanged: (value){
                                          listImageColor[index].colorName = value;
                                        },
                                        style: TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                          hintText: "Color name ...",
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: mainColor, width: 2.0),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h,),
                                Row(
                                  children: [
                                    Text("Color code:", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(width: 10.w,),
                                    Expanded(
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 25.w,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8.0), // Bo tròn góc bên trái trên
                                                  bottomLeft: Radius.circular(8.0), // Bo tròn góc bên trái dưới
                                                ),
                                                color: listImageColor[index].colorCode != null ? listImageColor[index].colorCode! : Colors.white,

                                              ),
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller:listImageColor[index].colorCode != null ? TextEditingController(text: convertColorToHex(listImageColor[index].colorCode!)) : null,
                                                readOnly: true,
                                                textAlignVertical: TextAlignVertical.center,
                                                style: TextStyle(fontSize: 14),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                                  border: InputBorder.none,
                                                  focusedBorder: InputBorder.none,
                                                  suffixIcon: GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text('Select color'),
                                                            content: SingleChildScrollView(
                                                              child: ColorPicker(
                                                                pickerColor: listImageColor[index].colorCode != null ? listImageColor[index].colorCode! : Colors.white,
                                                                onColorChanged: (color) {
                                                                  print("Color: " + color.toString());
                                                                  setState(() {
                                                                    listImageColor[index].colorCode = color;
                                                                  });
                                                                },
                                                                showLabel: true,
                                                                pickerAreaHeightPercent: 0.8,
                                                              ),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: const Text('Done'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(Icons.color_lens, size: 20,), // Biểu tượng chọn màu
                                                  ),
                                                ),

                                              ),
                                            ),
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
                      }
                  ) : Container(),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey
                      ),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 150.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey
                            ),
                            borderRadius: BorderRadius.circular(6)
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: (){
                                selectImage();
                              },
                                child: Icon(Icons.add_photo_alternate, color: Colors.grey, size: 50,)
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h,),
                        Row(
                          children: [
                            Text("Color name:", style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(width: 10.w,),
                            Expanded(
                              child: TextField(
                                controller: null,
                                style: TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                  hintText: "Color name ...",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: mainColor, width: 2.0),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h,),
                        Row(
                          children: [
                            Text("Color code:", style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(width: 10.w,),
                            Expanded(
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 25.w,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8.0), // Bo tròn góc bên trái trên
                                          bottomLeft: Radius.circular(8.0), // Bo tròn góc bên trái dưới
                                        ),
                                        color: _selectedColor ?? Colors.white,

                                      ),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _selectedColor != null ? TextEditingController(text: convertColorToHex(_selectedColor!)) : null,
                                        readOnly: true,
                                        textAlignVertical: TextAlignVertical.center,
                                        style: TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              _showColorPickerDialog(context);
                                            },
                                            child: Icon(Icons.color_lens, size: 20,), // Biểu tượng chọn màu
                                          ),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String convertColorToHex(Color color) {
    return color.value.toRadixString(16).padLeft(6, '0').toUpperCase();
  }
  void _showColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor != null ? _selectedColor! : Colors.white,
              onColorChanged: (color) {
                print("Color: " + color.toString());
                setState(() {
                  _selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
class ImageColorProduct{
  TextEditingController controller = TextEditingController();
  XFile image;
  String? colorName;
  Color? colorCode;

  ImageColorProduct(this.image, this.colorName, this.colorCode);
}