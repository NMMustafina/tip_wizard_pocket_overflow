import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PurchaseInfoSection extends StatefulWidget {
  final List<Map<String, String>> positions;
  final VoidCallback onAddPosition;
  final Function(int, String, String) onPositionChanged;

  const PurchaseInfoSection({
    super.key,
    required this.positions,
    required this.onAddPosition,
    required this.onPositionChanged,
  });

  @override
  State<PurchaseInfoSection> createState() => _PurchaseInfoSectionState();
}

class _PurchaseInfoSectionState extends State<PurchaseInfoSection> {
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> costControllers = [];
  List<TextEditingController> quantityControllers = [];

  List<FocusNode> nameFocusNodes = [];
  List<FocusNode> costFocusNodes = [];
  List<FocusNode> quantityFocusNodes = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.positions.length; i++) {
      _addControllerAndNode(i);
    }
  }

  void _addControllerAndNode(int index) {
    nameControllers.add(TextEditingController());
    costControllers.add(TextEditingController());
    quantityControllers.add(TextEditingController());

    nameFocusNodes.add(FocusNode()..addListener(() => setState(() {})));
    costFocusNodes.add(FocusNode()..addListener(() => setState(() {})));
    quantityFocusNodes.add(FocusNode()..addListener(() => setState(() {})));
  }

  @override
  void didUpdateWidget(PurchaseInfoSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.positions.length > nameControllers.length) {
      for (int i = nameControllers.length; i < widget.positions.length; i++) {
        _addControllerAndNode(i);
      }
    }
  }

  @override
  void dispose() {
    for (var controller in [
      ...nameControllers,
      ...costControllers,
      ...quantityControllers
    ]) {
      controller.dispose();
    }
    for (var node in [
      ...nameFocusNodes,
      ...costFocusNodes,
      ...quantityFocusNodes
    ]) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Purchasing information',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Column(
          children: List.generate(widget.positions.length, (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Item ${index + 1}',
                    style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                TextField(
                  controller: nameControllers[index],
                  focusNode: nameFocusNodes[index],
                  onChanged: (value) {
                    widget.onPositionChanged(index, 'name', value);
                    setState(() {});
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration(
                    'Name of position',
                    nameControllers[index],
                    nameFocusNodes[index],
                    'Enter name',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: costControllers[index],
                        focusNode: costFocusNodes[index],
                        onChanged: (value) {
                          widget.onPositionChanged(index, 'cost', value);
                          setState(() {});
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Cost',
                          labelStyle: const TextStyle(
                              color: Colors.white60, fontSize: 16),
                          hintText: costFocusNodes[index].hasFocus
                              ? 'Enter a value in \$'
                              : 'Tap to enter',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: const Color(0xFF151A22),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          prefixText: costControllers[index].text.isNotEmpty
                              ? '\$ '
                              : '',
                          prefixStyle: const TextStyle(
                              color: Colors.white60, fontSize: 16),
                          suffixIcon: costControllers[index].text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.white60),
                                  onPressed: () {
                                    costControllers[index].clear();
                                    widget.onPositionChanged(index, 'cost', '');
                                    setState(() {});
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: quantityControllers[index],
                        focusNode: quantityFocusNodes[index],
                        onChanged: (value) {
                          widget.onPositionChanged(index, 'quantity', value);
                          setState(() {});
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          'Quantity',
                          quantityControllers[index],
                          quantityFocusNodes[index],
                          'Enter quantity',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ),
        GestureDetector(
          onTap: () {
            widget.onAddPosition();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Click to add a new position',
                style: TextStyle(
                  color: Color(0xFF6C63FF),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.add_circle_outline, color: Color(0xFF6C63FF)),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(
      String label,
      TextEditingController controller,
      FocusNode focusNode,
      String focusedHint) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60, fontSize: 16),
      hintText: focusNode.hasFocus ? focusedHint : 'Tap to enter',
      hintStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xFF151A22),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear, color: Colors.white60),
              onPressed: () {
                controller.clear();
                setState(() {});
              },
            )
          : null,
    );
  }
}
