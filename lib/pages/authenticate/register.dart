import 'package:flutter/material.dart';
import 'package:pantry_chef/services/auth.dart';
import 'package:pantry_chef/shared/loading.dart';
import 'package:pantry_chef/style/styles.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String fname = '';
  String lname = '';
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
                title: Text('Sign up to Pantry Chef'),
                actions: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.person),
                    label: Text('Sign in'),
                    onPressed: () {
                      widget.toggleView();
                    },
                  )
                ],
              ),
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      // fname text field
                      SizedBox(height: 58.0),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? 'Enter a first name' : null,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'First name'),
                        onChanged: (val) {
                          setState(() => fname = val.trim());
                        },
                      ),
                      // lname text field
                      SizedBox(height: 20.0),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? 'Enter a last name' : null,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Last name'),
                        onChanged: (val) {
                          setState(() => lname = val.trim());
                        },
                      ),
                      // email text field
                      SizedBox(height: 20.0),
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
                        title: 'Register',
                        color: Colors.pink[400],
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    fname, lname, email, password);
                            if (result == null) {
                              setState(
                                  () => error = 'Please supply a valid email.');
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
            )
          );
  }
}
