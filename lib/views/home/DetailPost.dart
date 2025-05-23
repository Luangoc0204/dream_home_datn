import 'package:flutter/material.dart';

class DetaiPostPage extends StatefulWidget {
  const DetaiPostPage({super.key});

  @override
  State<DetaiPostPage> createState() => _DetaiPostPageState();
}

class _DetaiPostPageState extends State<DetaiPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        heightFactor:  MediaQuery.of(context).size.height,
        child: Text("Detail post page"),
      ),
    );
  }
}
