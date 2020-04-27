import 'package:flutter/material.dart';
import 'package:pantry_chef/services/auth.dart';
import 'package:pantry_chef/shared/loading.dart';
import 'package:pantry_chef/style/styles.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            //TODO: Find a decent image to use as our background...
            //! ________________________________________________________________
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     colorFilter: ColorFilter.mode(
            //         Colors.black.withOpacity(0.3), BlendMode.dstOut),
            //     image: AssetImage('assets/pantry_chef_green.png'),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            //! ________________________________________________________________
            child: Scaffold(
              // backgroundColor: Colors.transparent,
              resizeToAvoidBottomPadding: false,
              backgroundColor: Colors.grey[300],
              appBar: AppBar(
                backgroundColor: Colors.green,
                elevation: 0.0,
                title: Text('Sign in to Pantry Chef'),
                actions: <Widget>[
                  FlatButton.icon(
                      icon: Icon(Icons.person),
                      label: Text('Register'),
                      onPressed: () {
                        widget.toggleView();
                      })
                ],
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 58.0,
                      ),
                      // email text field
                      // ? SizedBox(height: 20.0),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your email'),
                        onChanged: (val) {
                          setState(() => email = val.trim());
                        },
                      ),
                      // password text field
                      SizedBox(height: 20.0),
                      TextFormField(
                        obscureText: true,
                        validator: (val) => val.length < 6
                            ? 'Enter a password 6+ chars long'
                            : null,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your password'),
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      // sign in button
                      SizedBox(height: 8.0),
                      RoundedButton(
                        title: 'Sign In',
                        color: Colors.pink[400],
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() => error =
                                  'Could not sign in with those credentials');
                              loading = false;
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
