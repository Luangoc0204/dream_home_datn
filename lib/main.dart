
import 'package:dreamhome/repository/service/CartService.dart';
import 'package:dreamhome/repository/service/CommentService.dart';
import 'package:dreamhome/repository/service/LikeService.dart';
import 'package:dreamhome/repository/service/OrderService.dart';
import 'package:dreamhome/repository/service/PostService.dart';
import 'package:dreamhome/repository/service/ProductService.dart';
import 'package:dreamhome/repository/service/ReviewService.dart';
import 'package:dreamhome/repository/service/ShopService.dart';
import 'package:dreamhome/repository/service/UserService.dart';
import 'package:dreamhome/viewmodels/CartViewModel.dart';
import 'package:dreamhome/viewmodels/CommentViewModel.dart';
import 'package:dreamhome/viewmodels/LikeViewModel.dart';
import 'package:dreamhome/viewmodels/OrderViewModel.dart';
import 'package:dreamhome/viewmodels/PostViewModel.dart';
import 'package:dreamhome/viewmodels/ProductViewModel.dart';
import 'package:dreamhome/viewmodels/ReviewViewModel.dart';
import 'package:dreamhome/viewmodels/ShopViewModel.dart';
import 'package:dreamhome/viewmodels/UserViewModel.dart';
import 'package:dreamhome/views/login/SignUpUser.dart';
import 'package:dreamhome/views/login/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  // Khởi tạo Firebase trước khi runApp
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,      // status bar color
    ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PostViewModel(postRepository: PostService()),),
          ChangeNotifierProvider(create: (_) => CommentViewModel(commentRepository: CommentService()),),
          ChangeNotifierProvider(create: (_) => UserViewModel(userRepository: UserService()),),
          ChangeNotifierProvider(create: (_) => ProductViewModel(productRepository: ProductService())),
          ChangeNotifierProvider(create: (_) => CartViewModel(cartRepository: CartService())),
          ChangeNotifierProvider(create: (_) => OrderViewModel(orderRepository: OrderService())),
          ChangeNotifierProvider(create: (_) => ShopViewModel(shopRepository: ShopService())),
          ChangeNotifierProvider(create: (_) => ReviewViewModel(reviewRepository: ReviewService())),
          ChangeNotifierProvider(create: (_) => LikeViewModel(likeRepository: LikeService())),

        ],
        child: const MyApp(),
    )

  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();

}
class _MyAppState extends State<MyApp>{
  var auth = FirebaseAuth.instance;
  var isLogin = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child){
        return MaterialApp(
          title: "DREAMHOME",
          home: ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              splitScreenMode: true,
              child: SplashScreen()
          ),
        );
      },
    );
  }

}







