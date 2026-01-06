import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TagInputField extends StatefulWidget {
  const TagInputField({super.key});

  @override
  State<TagInputField> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends State<TagInputField> {
  final chips = List.generate(1, (index) => 'Chip ${index + 1}').toSet();
  final controller = TextEditingController();
  late FocusNode inputFieldNode;

  @override
  void initState() {
    inputFieldNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    inputFieldNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void _addChip(String value) {
    setState(() {
      chips.add(value);
    });
    controller.clear();
    FocusScope.of(context).requestFocus(inputFieldNode);
  }

  void _removeChip(String value) {
    setState(() {
      chips.remove(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      radius: 10,
      // ignore: deprecated_member_use
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (key) {
          if (controller.text.isEmpty &&
              // ignore: deprecated_member_use
              key is RawKeyDownEvent &&
              key.data.logicalKey == LogicalKeyboardKey.backspace) {
            setState(() {
              chips.remove(chips.last);
            });
          }
        },
        child: Center(
          child: InputDecorator(
            decoration: const InputDecoration(
                filled: false,
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none),
            child: Wrap(
              spacing: 5,
              runSpacing: -7,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...chips.map(
                      (value) => Chip(
                    backgroundColor: const Color(0xFF00BAAB),
                    side: BorderSide.none,
                    label: Text(
                      value,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF222222)),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onDeleted: () {
                      _removeChip(value);
                    },
                    deleteIcon: const Icon(Icons.cancel),
                  ),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: controller,
                    focusNode: inputFieldNode,
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        final word = value.substring(0, value.length);
                        _addChip(word);
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      hintText: 'Tags',
                      hintStyle: TextStyle(color: Color(0xFF5E5E5E)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double? radius;
  final Color? color;
  const PrimaryContainer({
    super.key,
    this.radius,
    this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 30),
        boxShadow: [
          BoxShadow(
            color: color ?? const Color(0XFF1E1E1E),
          ),
          const BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 4,
            spreadRadius: 0,
            color: Colors.black,
          ),
        ],
      ),
      child: child,
    );
  }
}
