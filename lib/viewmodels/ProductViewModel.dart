import 'dart:convert';
import 'dart:io';

import 'package:dreamhome/models/Product.dart';
import 'package:dreamhome/repository/ProductRepository.dart';
import 'package:dreamhome/views/shop/AddEditProduct.dart';
import 'package:flutter/cupertino.dart';

class ProductViewModel with ChangeNotifier{
  late ProductRepository productRepository;

  ProductViewModel({required this.productRepository});
  List<Product>? _listProduct = [];
  List<Product>? _listProductShop = [];
  List<Product>? _listProductSearch = [];
  Product? _product;
  get listProduct{
    return _listProduct;
  }
  get listProductShop{
    return _listProductShop;
  }
  get listProductSearch{
    return _listProductSearch;
  }
  get product{
    return _product;
  }
  Future<void> getAllProductByType(String type) async {
    List? products = await productRepository.getAllProductByType(type);
    _listProduct!.clear();
    _listProduct!.addAll(products.map((item) => Product.fromMap(item)).toList());
    print("List product:" + products.toString());
    notifyListeners();
  }
  Future<void> searchProduct(String key) async {
    List? products = await productRepository.searchProduct(key);
    _listProductSearch!.clear();
    if (listProductSearch != null){
      _listProductSearch!.addAll(products!.map((item) => Product.fromMap(item)).toList());
    }
    print("List product:" + products.toString());
    notifyListeners();
  }
  Future<void> getAllProductByShop(String idShop) async {
    _listProductShop = [];
    List? products = await productRepository.getAllProductByShop(idShop);
    _listProductShop!.addAll(products.map((item) => Product.fromMap(item)).toList());
    notifyListeners();
  }
  Future<void> getAllProductByShopForUser(String idShop) async {
    _listProductShop!.clear();
    List? products = await productRepository.getAllProductByShopForUser(idShop);
    _listProductShop!.addAll(products.map((item) => Product.fromMap(item)).toList());
    notifyListeners();
  }
  Future<void> getProduct(String id) async {
    String productApi = await productRepository.getProduct(id);
    // Chuyển đổi chuỗi JSON thành Map<String, dynamic>
    Map<String, dynamic> productMap = jsonDecode(productApi);

    // Sử dụng hàm fromMap để tạo đối tượng Post từ Map
    _product = Product.fromMap(productMap);
    notifyListeners();
  }
  Future<void> addProductWithImages(Product product, List<File> images,  List<ProductImage> listImages) async {
    try {
      // Step 1: Gửi request để thêm post và nhận về id của post
      String productApi = await productRepository.addProduct(product);
      Map<String, dynamic> productMap = jsonDecode(productApi);
      debugPrint("productMap:" + productMap.toString());
      Product? productAdd = Product.fromMap(productMap);
      print("Product add:$productAdd");
      // notifyListeners();

      // Step 2: Nếu post được thêm thành công, thì upload ảnh
      if (images.isNotEmpty) {
        // print('Number of images: ${images.length}');
        String response = await productRepository.uploadImages(images, productAdd.id);
        for (int i = 0; i < listImages.length; i++) {
          listImages[i].url = '${productAdd.id}_$i.png';
        }
        print("List ProductImage:" + listImages.toString());
        String addImageResponse = await productRepository.addImageColorProduct(listImages, productAdd.id);
        Map<String, dynamic> productMapImage = jsonDecode(addImageResponse);
        _product = Product.fromMap(productMapImage);
        await Future.delayed(const Duration(seconds: 1));
        await productRepository.getProduct(productAdd.id);
        // print("_post: " + _post.toString());
        notifyListeners();
      }

    } catch (e) {
      print('Error: $e');
      // Xử lý lỗi nếu có
    }
  }
}