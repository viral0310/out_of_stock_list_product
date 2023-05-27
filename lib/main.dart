import 'dart:core';
import 'package:flutter/material.dart';

import 'package:product_db/provider/add_to_cart.dart';
import 'package:product_db/views/screens.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ProductProvider(),
      )
    ],
    builder: (context, _) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      );
    },
  ));
}
