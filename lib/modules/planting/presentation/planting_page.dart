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

  PlantingEntity? _processingEntity;
  File? _processingImage;
  bool isExpanding = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    _descFocusNode.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> _handleButtonTap() async {
    if (!_formKey.currentState!.validate()) return;
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

    setState(() {
      _processingEntity = entity;
      _processingImage = _image!;
      isExpanding = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final bool? result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => ProcessingPage(
          entity: _processingEntity!,
          image: _processingImage!,
        ),
        transitionDuration: const Duration(milliseconds: 600),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    setState(() => isExpanding = false);

    if (!mounted) return;

    if (result == true) {
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
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(title: const Text('Nova plantação')),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppThemeConstants.padding,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
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
                                const SizedBox(height: 20),
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
                                        height: context.screenHeight * .5,
                                        width: context.screenWidth,
                                        child: _image != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
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
                                                    style: context
                                                        .textTheme
                                                        .bodyLarge
                                                        ?.copyWith(
                                                          color: Colors
                                                              .grey
                                                              .shade700,
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
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Botão expansível acima de tudo
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            bottom: 16,
            left: isExpanding ? 0 : 16,
            right: isExpanding ? 0 : 16,
            height: isExpanding ? context.screenHeight : 50,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: context.myTheme.primaryContainer,
                borderRadius: BorderRadius.circular(
                  AppThemeConstants.mediumBorderRadius,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleButtonTap,
                  child: Center(
                    child: isExpanding
                        ? const SizedBox.shrink()
                        : _buildButtonLabel(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
