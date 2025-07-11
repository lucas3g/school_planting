// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:school_planting/core/constants/constants.dart';

class AppCircularIndicatorWidget extends StatelessWidget {
  final double? size;

  const AppCircularIndicatorWidget({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 50.0,
      height: size ?? 50.0,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(context.myTheme.primary),
      ),
    );
  }
}
