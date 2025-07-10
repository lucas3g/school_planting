import 'dart:async';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_planting/core/constants/constants.dart';
import 'package:school_planting/core/domain/entities/app_global.dart';
import 'package:school_planting/modules/planting/domain/entities/planting_entity.dart';
import 'package:school_planting/shared/components/app_snackbar.dart';
import 'package:school_planting/shared/components/custom_app_bar.dart';
import 'package:school_planting/shared/components/custom_button.dart';
import 'package:school_planting/shared/components/text_form_field.dart';
import 'package:school_planting/shared/themes/app_theme_constants.dart';
import 'package:uuid/uuid.dart';

import 'processing_page.dart';

class PlantingPage extends StatefulWidget {
  const PlantingPage({super.key});

  @override
  State<PlantingPage> createState() => _PlantingPageState();
}

class _PlantingPageState extends State<PlantingPage> {
  final TextEditingController _descController = TextEditingController();
  final FocusNode _descFocusNode = FocusNode();

  final ImagePicker _picker = ImagePicker();
  File? _image;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _saveButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light, // Para iOS
      ),
    );
  }

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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _descFocusNode.unfocus();

    if (_image == null) {
      showAppSnackbar(
        context,
        title: 'Atenção',
        message: 'Tire uma foto da planta',
        type: TypeSnack.warning,
      );

      return;
    }

    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (!mounted) return;

      showAppSnackbar(
        context,
        title: 'Atenção',
        message: 'Permita acesso à localização',
        type: TypeSnack.warning,
      );

      return;
    }

    final myPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final String uuid = const Uuid().v4();

    final entity = PlantingEntity(
      description: _descController.text,
      imageName: uuid,
      userId: AppGlobal.instance.user!.id.value,
      lat: myPosition.latitude,
      long: myPosition.longitude,
    );

    if (!mounted) return;

    final result = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) =>
            ProcessingPage(entity: entity, image: _image!),
        transitionsBuilder: (context, animation, __, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );

          return Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: curved,
              builder: (context, child) {
                return ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20 * (1 - curved.value)),
                  child: FractionallySizedBox(
                    heightFactor: curved.value,
                    widthFactor: 1.0,
                    alignment: Alignment.bottomCenter,
                    child: child,
                  ),
                );
              },
              child: child,
            ),
          );
        },
      ),
    );

    if (result == true && mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildButtonLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.save, size: 20, color: Colors.white),
        const SizedBox(width: 10),
        Text(
          'Salvar plantação',
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: const Text('Nova plantação')),
      bottomSheet: Padding(
        padding: EdgeInsets.only(
          left: AppThemeConstants.padding,
          right: AppThemeConstants.padding,
          top: AppThemeConstants.padding,
          bottom: AppThemeConstants.padding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            AppCustomButton(
              buttonKey: _saveButtonKey,
              expands: true,
              onPressed: _save,
              label: _buildButtonLabel(),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppThemeConstants.padding,
              right: AppThemeConstants.padding,
              top: AppThemeConstants.padding,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Descrição da Planta',
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          AppTextFormField(
                            focusNode: _descFocusNode,
                            borderColor: Colors.white,
                            controller: _descController,
                            hint: 'Escreva sobre a planta',
                            textArea: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Descrição é obrigatória';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Foto da Planta',
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: _takePhoto,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: DottedBorder(
                                options: RectDottedBorderOptions(
                                  color: _image != null
                                      ? Colors.transparent
                                      : Colors.white,
                                  strokeWidth: 2,
                                  dashPattern: const [10, 5],
                                ),
                                child: SizedBox(
                                  height: context.screenHeight * .3,
                                  width: context.screenWidth,
                                  child: _image != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            AppThemeConstants
                                                .mediumBorderRadius,
                                          ),
                                          child: Image.file(
                                            _image!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.camera_alt,
                                              size: 50,
                                              color: Colors.grey.shade700,
                                            ),
                                            Text(
                                              'Toque para tirar uma foto',
                                              style: context.textTheme.bodyLarge
                                                  ?.copyWith(
                                                    color: Colors.grey.shade700,
                                                  ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
