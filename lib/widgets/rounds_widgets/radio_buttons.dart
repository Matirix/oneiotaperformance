import 'package:flutter/material.dart';

/// This is used in the rounds entry page to select options for Fairway,
/// Green, and ChipSandshot.
class RadioGroup extends StatefulWidget {
  final List<RadioItem> items;
  final void Function(RadioItem)? onChanged;
  final RadioItem? defaultSelection;

  const RadioGroup({
    super.key,
    required this.items,
    this.onChanged,
    this.defaultSelection,
  });

  @override
  State<RadioGroup> createState() => RadioGroupState();
}

class RadioGroupState extends State<RadioGroup> {
  RadioItem? selectedItem;

  @override
  void initState() {
    selectedItem = widget.defaultSelection;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.items.map((item) {
        final selected = item == selectedItem;
        final circleColor = selected ? const Color(0xff87CA80) : Colors.white;

        return InkWell(
          onTap: () {
            setState(() {
              selectedItem = item;
            });
            widget.onChanged?.call(item);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
            ),
            child: Column(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circleColor,
                  ),
                  child: Icon(
                    item.icon,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                Text(
                  item.label,
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

///Radio Item class
class RadioItem {
  final IconData icon;
  final String label;

  RadioItem({required this.icon, required this.label});
}
