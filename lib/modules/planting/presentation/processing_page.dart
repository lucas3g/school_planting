import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_planting/core/di/dependency_injection.dart';
import 'package:school_planting/modules/planting/domain/entities/planting_entity.dart';
import 'package:school_planting/modules/planting/domain/usecases/create_planting_usecase.dart';
import 'package:school_planting/modules/planting/domain/usecases/validate_plant_image_usecase.dart';

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
      setState(() => _message = 'Imagem enviada não é uma planta');
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context, false);
      return;
    }

    setState(() => _message = 'Enviando registro para o servidor');
    final result =
        await create(CreatePlantingParams(entity: widget.entity, image: widget.image));

    if (!mounted) return;

    result.get((failure) async {
      setState(() => _message = failure.message);
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context, false);
    }, (_) async {
      setState(() => _success = true);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: _success
            ? Lottie.asset(
                'assets/lotties/success.json',
                width: 150,
                repeat: false,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  const SizedBox(height: 20),
                  Text(
                    _message,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}
