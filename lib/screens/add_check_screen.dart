import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:tip_calculator/screens/check_screen.dart';

import '../models/check_model.dart';
import '../services/check_service.dart';
import '../services/settings_service.dart';
import 'cover_section.dart';
import 'custom_button.dart';
import 'facility_info_section.dart';
import 'info_section.dart';
import 'loader_screen.dart';
import 'personal_assessment_section.dart';
import 'purchase_info_section.dart';
import 'tax_section.dart';

class AddCheckScreen extends StatefulWidget {
  const AddCheckScreen({super.key});

  @override
  State<AddCheckScreen> createState() => _AddCheckScreenState();
}

class _AddCheckScreenState extends State<AddCheckScreen> {
  List<Map<String, String>> positions = [
    {'name': '', 'cost': '', 'quantity': ''}
  ];
  List<ImageFile> images = [];
  bool isFormValid = false;
  String? personalAssessment;
  double? defaultTipPercentage;

  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDefaults();
  }

  Future<void> _loadDefaults() async {
    final savedTip = await SettingsService.getDefaultTipPercentage();
    final savedTax = await SettingsService.getDefaultTaxAmount();
    if (savedTip != null) {
      defaultTipPercentage = savedTip;
    }
    if (savedTax != null) {
      _taxController.text = savedTax.toStringAsFixed(2);
    }
    _validateForm();
    setState(() {});
  }

  void _addPosition() {
    setState(() {
      positions.add({'name': '', 'cost': '', 'quantity': ''});
    });
    _validateForm();
  }

  void _onImagesChanged(List<ImageFile> imgs) {
    setState(() {
      images = imgs;
    });
  }

  void _onPositionChanged(int index, String key, String value) {
    setState(() {
      positions[index][key] = value;
    });
    _validateForm();
  }

  void _validateForm() {
    bool hasValidPosition = positions.every((pos) =>
        pos['name']!.isNotEmpty &&
        pos['cost']!.isNotEmpty &&
        pos['quantity']!.isNotEmpty);

    setState(() {
      isFormValid = hasValidPosition &&
          _placeController.text.isNotEmpty &&
          _taxController.text.isNotEmpty;
    });
  }

  Future<void> _saveCheck() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const LoaderScreen(),
    );

    final tempDir = Directory.systemTemp;
    List<String> imagePaths = [];

    for (var imageFile in images) {
      if (imageFile.bytes != null) {
        final file = File(
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await file.writeAsBytes(imageFile.bytes!);
        imagePaths.add(file.path);
      }
    }

    final formattedDate = DateFormat('MM.dd.yy').format(DateTime.now());

    final check = CheckModel(
      placeName: _placeController.text,
      positions: positions,
      tax: double.tryParse(_taxController.text),
      imagesPaths: imagePaths,
      placeAddress:
          _addressController.text.isNotEmpty ? _addressController.text : null,
      personalAssessment: personalAssessment,
      date: formattedDate,
      tipPercentage: defaultTipPercentage,
    );
    final service = CheckService();
    await service.addCheck(check);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    _navigateToCheckScreen(check);
  }

  void _navigateToCheckScreen(CheckModel check) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CheckScreen(check: check),
      ),
    );
  }

  Future<void> _showExitConfirmation() async {
    final shouldLeave = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Leave the page'),
          content: const Text(
              'Are you sure you want to log out? In this case, your check will not be added'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;

    if (shouldLeave ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: _showExitConfirmation,
        ),
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Check creation',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CoverSection(onImagesChanged: _onImagesChanged),
                const SizedBox(height: 24),
                FacilityInfoSection(
                  nameController: _placeController,
                  addressController: _addressController,
                  onChanged: _validateForm,
                ),
                const SizedBox(height: 24),
                PurchaseInfoSection(
                  positions: positions,
                  onAddPosition: _addPosition,
                  onPositionChanged: _onPositionChanged,
                ),
                const SizedBox(height: 24),
                TaxSection(
                  title: 'Tax information',
                  controller: _taxController,
                  onChanged: _validateForm,
                ),
                const SizedBox(height: 24),
                const InfoSection(
                  infoText:
                      'Thereafter, the application will take into account the tax specified by you for the first time. You can change its value in the application settings.',
                ),
                const SizedBox(height: 24),
                PersonalAssessmentSection(
                  onAssessmentSelected: (value) {
                    setState(() {
                      personalAssessment = value;
                    });
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: CustomButton(
                isEnabled: isFormValid,
                onPressed: _saveCheck,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
