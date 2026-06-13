import 'package:catalog/core/themes/theme.dart';
import 'package:catalog/views/screens/product_list_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      title: 'Catalog',
      home: Scaffold(
        appBar: AppBar(title: const Text('Catalog')),
        body: ProductListScreen(),
      ),
    );
  }
}
