import 'package:flutter/material.dart';
import 'package:school_planting/shared/components/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: CustomAppBar(title: Text('Home page')));
  }
}
