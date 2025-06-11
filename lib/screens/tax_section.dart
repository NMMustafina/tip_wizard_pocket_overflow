import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaxSection extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  final String? title;
  final TextInputType keyboardType;

  const TaxSection({
    super.key,
    required this.controller,
    required this.onChanged,
    this.title,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
  });

  @override
  State<TaxSection> createState() => _TaxSectionState();
}

class _TaxSectionState extends State<TaxSection> {
  bool isFilled = false;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    widget.controller.addListener(() {
      setState(() {
        isFilled = widget.controller.text.isNotEmpty;
      });
      widget.onChanged();
    });
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void clearField() {
    widget.controller.clear();
    FocusScope.of(context).unfocus();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null && widget.title!.isNotEmpty) ...[
          Text(
            widget.title!,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 12),
        ],
        TextField(
          controller: widget.controller,
          focusNode: focusNode,
          keyboardType: widget.keyboardType,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?$')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              if (newValue.text.isEmpty) return newValue;
              final double? value = double.tryParse(newValue.text);
              if (value != null && value <= 100) {
                return newValue;
              }
              return oldValue;
            }),
          ],
          style: const TextStyle(color: Colors.white),
          onChanged: (value) => widget.onChanged(),
          decoration: InputDecoration(
            hintText:
                focusNode.hasFocus ? 'Enter a value in %' : 'Tap to enter',
            hintStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: const Color(0xFF151A22),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            suffixText: isFilled ? '%' : null,
            suffixStyle: const TextStyle(color: Colors.white60, fontSize: 16),
            suffixIcon: isFilled
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.white60),
                    onPressed: clearField,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
