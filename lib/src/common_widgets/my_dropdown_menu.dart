import 'package:flutter/material.dart';

class MyDropdownMenu extends StatefulWidget {
  final List<String> dropdownMenuEntries;
  final TextEditingController? controller;
  const MyDropdownMenu(
      {super.key, required this.dropdownMenuEntries, this.controller});

  @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  String? valueMenu;

  @override
  void initState() {
    super.initState();
    valueMenu = widget.dropdownMenuEntries.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Center(
        child: DropdownMenu<String>(
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey[400],
          ),
          width: MediaQuery.of(context).size.width / 1.04,
          initialSelection: widget.dropdownMenuEntries.first,
          controller: widget.controller,
          onSelected: (value) {
            setState(() {
              valueMenu = value;
            });
          },
          dropdownMenuEntries: widget.dropdownMenuEntries
              .map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        ),
      ),
    );
  }
}
