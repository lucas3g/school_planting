import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/modules/home/domain/entities/planting_detail_entity.dart';
import 'package:school_planting/modules/home/presentation/widgets/dialog_view_image_widget.dart';
import 'package:school_planting/shared/components/app_circular_indicator_widget.dart';
import 'package:school_planting/shared/utils/formatters.dart';

class ModalPlantingInfoWidget extends StatefulWidget {
  final PlantingDetailEntity detail;
  final String tag;

  const ModalPlantingInfoWidget({
    super.key,
    required this.detail,
    required this.tag,
  });

  @override
  State<ModalPlantingInfoWidget> createState() =>
      _ModalPlantingInfoWidgetState();
}

class _ModalPlantingInfoWidgetState extends State<ModalPlantingInfoWidget> {
  void _showImage(String url, String tag) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => Material(
          color: Colors.transparent,
          child: DialogViewImageWidget(path: url, tag: tag),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: context.myTheme.primaryContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: widget.tag,
                child: Material(
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () => _showImage(widget.detail.imageUrl, widget.tag),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.detail.imageUrl,
                        height: context.screenHeight * 0.25,
                        width: context.screenWidth,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        placeholder: (context, url) =>
                            const Center(child: AppCircularIndicatorWidget()),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      widget.detail.userImageUrl,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.detail.userName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    widget.detail.createdAt.diaMesAnoHora(),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              Divider(color: Colors.white54),
              Text(widget.detail.description),
            ],
          ),
        ),
      ),
    );
  }
}
