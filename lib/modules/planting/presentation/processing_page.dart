import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/core/di/dependency_injection.dart';
import 'package:school_planting/core/domain/entities/app_assets.dart';
import 'package:school_planting/modules/planting/domain/entities/planting_entity.dart';
import 'package:school_planting/modules/planting/domain/usecases/create_planting_usecase.dart';
import 'package:school_planting/modules/planting/domain/usecases/validate_plant_image_usecase.dart';
import 'package:school_planting/shared/components/app_circular_indicator_widget.dart';

class ProcessingPage extends StatefulWidget {
  final PlantingEntity entity;
  final File image;
  const ProcessingPage({super.key, required this.entity, required this.image});

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  String _message = 'verificando imagem';
  bool _success = false;

  @override
  void initState() {
    super.initState();
    unawaited(_process());
  }

  Future<void> _process() async {
    final validate = getIt<ValidatePlantImageUseCase>();
    final create = getIt<CreatePlantingUseCase>();

    final validation = await validate(widget.image);

    if (validation.isLeft || !validation.isRight) {
      if (!mounted) return;
      setState(() {
        _message = 'Imagem enviada não é uma planta';
      });
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context, false);
      return;
    }

    setState(() => _message = 'Enviando registro para o servidor');
    final result = await create(
      CreatePlantingParams(entity: widget.entity, image: widget.image),
    );

    if (!mounted) return;

    result.get(
      (failure) async {
        setState(() => _message = failure.message);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context, false);
      },
      (_) async {
        setState(() => _success = true);
        await Future.delayed(const Duration(milliseconds: 1400));
        if (mounted) Navigator.pop(context, true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        child: Center(
          child: _success
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      AppAssets.lottieSuccess,
                      width: context.screenWidth * .5,
                      repeat: true,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Planta registrada com sucesso!',
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppCircularIndicatorWidget(),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (child, animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(animation);
                        if (animation.status == AnimationStatus.reverse) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        }
                        return SlideTransition(
                          position: offsetAnimation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        _message,
                        key: ValueKey<String>(_message),
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
