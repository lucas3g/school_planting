import 'package:flutter/material.dart';
import 'package:school_planting/modules/home/presentation/widgets/card_user_widget.dart';
import 'package:school_planting/modules/home/presentation/widgets/map_planting_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [MapPlantingWidget(), CardUserWidget()]),
    );
  }
}
