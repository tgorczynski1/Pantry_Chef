import 'package:flutter/material.dart';
import 'package:pantry_chef/models/user.dart';
import 'package:pantry_chef/pages/authenticate/authenticate.dart';
import 'package:pantry_chef/pages/home/home.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // print('USER ID: ' + user.uid.toString());

    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
