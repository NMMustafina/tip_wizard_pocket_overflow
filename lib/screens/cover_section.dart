import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class CoverSection extends StatefulWidget {
  final Function(List<ImageFile>) onImagesChanged;

  const CoverSection({super.key, required this.onImagesChanged});

  @override
  State<CoverSection> createState() => _CoverSectionState();
}

class _CoverSectionState extends State<CoverSection> {
  final ImagePicker _imagePicker = ImagePicker();

  late final MultiImagePickerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = MultiImagePickerController(
      maxImages: 3,
      picker: (count, params) async {
        final pickedFiles = await _imagePicker.pickMultiImage();
        List<ImageFile> result = [];
        for (var file in pickedFiles) {
          final bytes = await file.readAsBytes();
          final extension = file.name.split('.').last;
          result.add(
            ImageFile(
              UniqueKey().toString(),
              name: file.name,
              extension: extension,
              bytes: bytes,
            ),
          );
        }
        return result;
      },
    );

    _controller.addListener(() {
      widget.onImagesChanged(_controller.images.toList());
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text('Take a photo',
                    style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text('Choose from gallery',
                    style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  await _controller.pickImages();
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.white),
                title:
                    const Text('Cancel', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final extension = pickedFile.name.split('.').last;
      final imageFile = ImageFile(
        UniqueKey().toString(),
        name: pickedFile.name,
        extension: extension,
        bytes: bytes,
      );
      _controller.addImage(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = _controller.images.toList();
    final imagesCount = images.length;
    final isAddDisabled = imagesCount >= 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Cover of the check',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            Spacer(),
            Text('(optional)', style: TextStyle(color: Colors.white54)),
          ],
        ),
        const SizedBox(height: 12),
        if (imagesCount > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1,
              children: List.generate(imagesCount, (index) {
                final image = images[index];
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: image.bytes != null
                          ? Image.memory(
                              image.bytes!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox(),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0x99FFFFFF),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.black, size: 14),
                          onPressed: () {
                            _controller.removeImage(image);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ElevatedButton(
          onPressed: isAddDisabled
              ? null
              : () async {
                  await _showImageSourceDialog();
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
            disabledBackgroundColor: const Color(0xFF021128),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.fromLTRB(4, 4, 20, 4),
            elevation: 0,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isAddDisabled ? Colors.white70 : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/icon_camera.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      isAddDisabled
                          ? const Color(0xFF021128)
                          : const Color(0xFF6C63FF),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Add a photo',
                          style: TextStyle(
                              color:
                                  isAddDisabled ? Colors.white70 : Colors.white,
                              fontSize: 16),
                        ),
                        const Spacer(),
                        Text(
                          '($imagesCount/3)',
                          style: TextStyle(
                              color: isAddDisabled
                                  ? Colors.white70
                                  : Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cover will help you navigate the app better',
                      style: TextStyle(
                          color:
                              isAddDisabled ? Colors.white38 : Colors.white70,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
