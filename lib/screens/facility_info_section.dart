import 'package:flutter/material.dart';

class FacilityInfoSection extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController addressController;
  final VoidCallback onChanged;

  const FacilityInfoSection({
    super.key,
    required this.nameController,
    required this.addressController,
    required this.onChanged,
  });

  @override
  State<FacilityInfoSection> createState() => _FacilityInfoSectionState();
}

class _FacilityInfoSectionState extends State<FacilityInfoSection> {
  bool isNameFilled = false;
  bool isAddressFilled = false;

  late FocusNode nameFocusNode;
  late FocusNode addressFocusNode;

  @override
  void initState() {
    super.initState();

    nameFocusNode = FocusNode();
    addressFocusNode = FocusNode();

    widget.nameController.addListener(() {
      setState(() {
        isNameFilled = widget.nameController.text.isNotEmpty;
      });
    });
    widget.addressController.addListener(() {
      setState(() {
        isAddressFilled = widget.addressController.text.isNotEmpty;
      });
    });

    nameFocusNode.addListener(() {
      setState(() {});
    });
    addressFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    addressFocusNode.dispose();
    super.dispose();
  }

  void clearField(TextEditingController controller) {
    controller.clear();
    FocusScope.of(context).unfocus();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Facility information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: widget.nameController,
          focusNode: nameFocusNode,
          onChanged: (value) => widget.onChanged(),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Name of place',
            labelStyle: const TextStyle(color: Colors.white60, fontSize: 16),
            hintText:
                nameFocusNode.hasFocus ? 'Enter the text' : 'Tap to enter',
            hintStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: const Color(0xFF151A22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isNameFilled
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => clearField(widget.nameController),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: widget.addressController,
          focusNode: addressFocusNode,
          onChanged: (value) => widget.onChanged(),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            label: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Address of place',
                  style: TextStyle(color: Colors.white60, fontSize: 16),
                ),
                Text(
                  '(optional)',
                  style: TextStyle(color: Colors.white38, fontSize: 14),
                ),
              ],
            ),
            hintText:
                addressFocusNode.hasFocus ? 'Enter the text' : 'Tap to enter',
            hintStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: const Color(0xFF151A22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isAddressFilled
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => clearField(widget.addressController),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
