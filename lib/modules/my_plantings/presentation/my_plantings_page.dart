import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/core/di/dependency_injection.dart';
import 'package:school_planting/modules/home/presentation/widgets/dialog_view_image_widget.dart';
import 'package:school_planting/modules/my_plantings/presentation/controller/my_plantings_bloc.dart';
import 'package:school_planting/modules/my_plantings/presentation/controller/my_plantings_events.dart';
import 'package:school_planting/modules/my_plantings/presentation/controller/my_plantings_states.dart';
import 'package:school_planting/shared/components/app_circular_indicator_widget.dart';
import 'package:school_planting/shared/components/app_snackbar.dart';
import 'package:school_planting/shared/components/custom_app_bar.dart';
import 'package:school_planting/shared/themes/app_theme_constants.dart';
import 'package:school_planting/shared/utils/formatters.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class MyPlantingsPage extends StatefulWidget {
  const MyPlantingsPage({super.key});

  @override
  State<MyPlantingsPage> createState() => _MyPlantingsPageState();
}

class _MyPlantingsPageState extends State<MyPlantingsPage> {
  final MyPlantingsBloc _bloc = getIt<MyPlantingsBloc>();

  @override
  void initState() {
    super.initState();

    _bloc.add(LoadMyPlantingsEvent());
  }

  void _showImage(String url, String tag) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => DialogViewImageWidget(path: url, tag: tag),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: const Text('Minhas Plantações')),
      body: SafeArea(
        child: BlocConsumer<MyPlantingsBloc, MyPlantingsStates>(
          bloc: _bloc,
          listener: (context, state) {
            if (state is MyPlantingsFailureState) {
              showAppSnackbar(
                context,
                title: 'Erro',
                message: state.message,
                type: TypeSnack.error,
              );
            }
          },
          builder: (context, state) {
            if (state is MyPlantingsLoadingState) {
              return const Center(child: AppCircularIndicatorWidget());
            }

            if (state is MyPlantingsSuccessState) {
              if (state.plantings.isEmpty) {
                return const Center(
                  child: Text('Nenhuma plantação encontrada'),
                );
              }

              return SuperListView.separated(
                padding: const EdgeInsets.all(AppThemeConstants.padding),
                itemCount: state.plantings.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = state.plantings[index];
                  final tag = item.imageUrl.split('/').last;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppThemeConstants.largeBorderRadius,
                      ),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => _showImage(item.imageUrl, tag),
                          child: Hero(
                            tag: tag,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  AppThemeConstants.largeBorderRadius,
                                ),
                                topRight: Radius.circular(
                                  AppThemeConstants.largeBorderRadius,
                                ),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: item.imageUrl,
                                height: context.screenHeight * 0.25,
                                width: context.screenWidth,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                                placeholder: (context, url) => const Center(
                                  child: AppCircularIndicatorWidget(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                            AppThemeConstants.mediumPadding,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.createdAt.diaMesAnoHora(),
                                style: context.textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(item.description),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
