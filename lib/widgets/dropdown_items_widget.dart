import 'package:flutter/material.dart';

class DropdownItems extends StatefulWidget {
  const DropdownItems(
      {super.key, required this.itemsList, required this.initialItem, required this.callback});
  final List<String>? itemsList;
  final String? initialItem;
  final Function(String) callback;
  @override
  State<DropdownItems> createState() => _DropdownItemsState();
}

class _DropdownItemsState extends State<DropdownItems> {
  String? selectedItem;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          labelText: 'Format du fichier de sortie',
          labelStyle: const TextStyle(color: Colors.grey),
        ),
        hint: (widget.initialItem == null)
            ? const Text('Choix du format')
            : Text(widget.initialItem!),
        value: selectedItem,
        items: widget.itemsList!
            .map((label) => DropdownMenuItem(value: label, child: Text(label)))
            .toList(),
        onChanged: (value) => setState(() {
          selectedItem = value;
          widget.callback(selectedItem!);
        }),
      ),
    );
  }
}
