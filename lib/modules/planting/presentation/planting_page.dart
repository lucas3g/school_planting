import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/core/di/dependency_injection.dart';
import 'package:school_planting/core/domain/entities/app_global.dart';
import 'package:school_planting/modules/planting/domain/entities/planting_entity.dart';
import 'package:school_planting/modules/planting/presentation/controller/planting_bloc.dart';
import 'package:school_planting/modules/planting/presentation/controller/planting_events.dart';
import 'package:school_planting/modules/planting/presentation/controller/planting_states.dart';
import 'package:school_planting/shared/components/app_circular_indicator_widget.dart';
import 'package:school_planting/shared/components/app_snackbar.dart';
import 'package:school_planting/shared/components/custom_app_bar.dart';
import 'package:school_planting/shared/components/custom_button.dart';
import 'package:school_planting/shared/components/text_form_field.dart';
import 'package:school_planting/shared/themes/app_theme_constants.dart';

class PlantingPage extends StatefulWidget {
  const PlantingPage({super.key});

  @override
  State<PlantingPage> createState() => _PlantingPageState();
}

class _PlantingPageState extends State<PlantingPage> {
  final PlantingBloc _bloc = getIt<PlantingBloc>();
  final TextEditingController _descController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> _save() async {
    if (_image == null) {
      showAppSnackbar(
        context,
        title: 'Erro',
        message: 'Tire uma foto da planta',
        type: TypeSnack.error,
      );
      return;
    }

    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      showAppSnackbar(
        context,
        title: 'Erro',
        message: 'Permita acesso à localização',
        type: TypeSnack.error,
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final String uuid = const Uuid().v4();

    final entity = PlantingEntity(
      description: _descController.text,
      imageName: uuid,
      userId: AppGlobal.instance.user!.id.value,
      latitude: position.latitude,
      longitude: position.longitude,
    );

    _bloc.add(CreatePlantingEvent(entity: entity, image: _image!));
  }

  Widget _handleButtonState(PlantingStates state) {
    if (state is PlantingLoadingState) {
      return const AppCircularIndicatorWidget(size: 20);
    }

    return Text(
      'Salvar',
      style: context.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: const Text('Nova plantação')),
      body: BlocListener<PlantingBloc, PlantingStates>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is PlantingSuccessState) {
            showAppSnackbar(
              context,
              title: 'Sucesso',
              message: 'Plantação registrada',
              type: TypeSnack.success,
            );
            Navigator.pop(context);
          }
          if (state is PlantingFailureState) {
            showAppSnackbar(
              context,
              title: 'Erro',
              message: state.message,
              type: TypeSnack.error,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppThemeConstants.padding),
          child: Column(
            children: [
              AppTextFormField(
                controller: _descController,
                hint: 'Descrição da planta',
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _takePhoto,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(
                      AppThemeConstants.mediumBorderRadius,
                    ),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppThemeConstants.mediumBorderRadius,
                          ),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                      : Icon(Icons.camera_alt, size: 50, color: Colors.grey.shade700),
                ),
              ),
              const Spacer(),
              BlocBuilder<PlantingBloc, PlantingStates>(
                bloc: _bloc,
                builder: (context, state) {
                  return AppCustomButton(
                    expands: true,
                    onPressed: () => _save(),
                    label: _handleButtonState(state),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
