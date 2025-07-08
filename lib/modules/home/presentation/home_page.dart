import 'package:flutter/material.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/modules/home/presentation/widgets/card_user_widget.dart';
import 'package:school_planting/modules/home/presentation/widgets/map_planting_widget.dart';
import 'package:school_planting/shared/themes/app_theme_constants.dart';
import 'package:school_planting/core/domain/entities/named_routes.dart';

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
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppThemeConstants.largeBorderRadius,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: () {
          Navigator.pushNamed(context, NamedRoutes.planting.route);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.park_rounded, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              'Plantar',
              style: context.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
