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
    return Container(
      child: TextFormField(
        controller: this.searchBarController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
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
    );
  }
}
