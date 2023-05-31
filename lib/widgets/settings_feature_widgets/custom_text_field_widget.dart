import 'package:flutter/material.dart';

/// A row containing a label, a text field, and a tooltip.
class CustomTextField extends StatelessWidget {
  String label;
  String tooltip;
  bool isEditable;
  bool showHint;

  CustomTextField({
    required this.label,
    required this.tooltip,
    required this.isEditable,
    required this.showHint,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            showHint
                ? Tooltip(
                    message: tooltip,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.info_outline),
                      color: Colors.grey,
                      iconSize: 12,
                    ),
                  )
                : Container(),
          ],
        ),
        Container(
          width: 170,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            style: const TextStyle(
              fontSize: 12,
            ),
            decoration: InputDecoration(
              hintText: "Placeholder",
              enabled: isEditable,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
