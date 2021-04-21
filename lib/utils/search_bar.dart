import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function onChange;
  final String placeholder;
  final TextEditingController searchBarController;
  SearchBar(
      {@required this.onChange,
      @required this.placeholder,
      @required this.searchBarController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 15.0, 8.0, 4.0),
      child: Container(
        child: TextFormField(
          controller: this.searchBarController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            hintText: this.placeholder,
          ),
          onChanged: (value) {
            this.onChange(value);
          },
          validator: (value) {
            if (value.isEmpty) {
              return '';
            }
            return null;
          },
        ),
      ),
    );
  }
}
