import 'package:flutter/material.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/core/domain/entities/app_global.dart';
import 'package:school_planting/shared/themes/app_theme_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppThemeConstants.mediumPadding),
                decoration: BoxDecoration(
                  color: context.myTheme.onPrimary,
                  borderRadius: BorderRadius.circular(
                    AppThemeConstants.largeBorderRadius,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        AppGlobal.instance.user!.imageUrl.value,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppGlobal.instance.user!.name.value,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
