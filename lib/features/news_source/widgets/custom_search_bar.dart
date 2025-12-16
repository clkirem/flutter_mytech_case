import 'package:flutter/material.dart';
import 'package:flutter_mytech_case/core/constants.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required TextEditingController searchController,
    required this.inputFillColor,
    required this.hintTextColor,
    required this.onSearch,
    required this.controller,
  }) : _searchController = searchController;

  final TextEditingController _searchController;
  final Color inputFillColor;
  final Color hintTextColor;
  final Function(String) onSearch;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: _searchController,
        onChanged: onSearch,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search for a source...',
          hintStyle: TextStyle(color: hintTextColor),
          filled: true,
          fillColor: inputFillColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          prefixIcon: Icon(Icons.search, color: hintTextColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: primaryColor, width: 2.0),
          ),
        ),
      ),
    );
  }
}
