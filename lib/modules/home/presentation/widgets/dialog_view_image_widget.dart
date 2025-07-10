// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:school_planting/core/constants/constants.dart';

class DialogViewImageWidget extends StatelessWidget {
  final String path;
  final String tag;

  const DialogViewImageWidget({
    super.key,
    required this.path,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Hero(
            tag: tag,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: path,
                  fit: BoxFit.fitHeight,
                  filterQuality: FilterQuality.high,
                  height: context.screenHeight * .8,
                  width: context.screenWidth,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
