import 'package:flutter/material.dart';

class LoginLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 48.0,
      backgroundColor: Colors.transparent,
      child: Image.network(
          "https://images.vexels.com/media/users/3/144230/isolated/preview/79526c38c6e5fe4b75f08d2d3a5af28c-conta-gotas-s--mbolo-m--dico-cruz-by-vexels.png"),
    );
  }
}
