import 'package:flutter/material.dart';
import 'package:pantry_chef/models/user.dart';
import 'package:pantry_chef/pages/wrapper.dart';
import 'package:pantry_chef/services/auth.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await RecipeViewModel.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
        // set true for debug banner
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
