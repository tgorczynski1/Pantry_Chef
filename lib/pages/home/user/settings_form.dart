import 'dart:io';

import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pantry_chef/main.dart';
import 'package:pantry_chef/models/user.dart';
import 'package:pantry_chef/services/db_user_collection.dart';
import 'package:pantry_chef/shared/loading.dart';
import 'package:pantry_chef/style/styles.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, bool>> _labels = [
    {'title': true, 'value': false},
    // 'Vegetarian': false,
    // 'Lactose-free': false,
    // 'Celiac': false,
    // 'Keto': false,
    // 'Diabetes': false
  ];

  String _currentFName;
  String _currentLName;
  bool _isSubscriber;
  String _currentAge;
  String _currentWeight;
  bool _vegan;
  bool _vegetarian;
  bool _lactosefree;
  bool _keto;
  bool _diabetes;
  File _image;
  var _uploadedFileURL;
  Image text;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    Future getImage() async {
      await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
        setState(() {
          _image = image;
          //print('asd' + _image.toString());
        });
      });
    }

    var _stream = UserDatabaseService(uid: user.uid).userData;
    return StreamBuilder<UserData>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;

            _uploadedFileURL = userData.imageurl;

            //!______________________________
            //! FOR TESTING
            // _favorites.add('Recipe02');
            //? not the best test since it returns one for each user in the db
            //!______________________________
            return Form(
              key: _formKey,
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      'Update your profile settings.',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),

                    SizedBox(height: 20.0),
                    _image != null
                        ? Image.file(_image)
                        : _uploadedFileURL != null
                            ? CircleAvatar(
                                radius: 85,
                                backgroundImage: NetworkImage(_uploadedFileURL),
                              )
                            : Container(),
                    _image == null
                        ? RaisedButton(
                            child: Text('Choose File'),
                            color: Colors.cyan,
                            onPressed: getImage,
                            //onPressed: null,
                          )
                        : Container(),
                    _image != null
                        ? RaisedButton(
                            child: Text('Clear Selection'),
                            onPressed: () async {
                              await UserDatabaseService(uid: user.uid)
                                  .updateUserDataSingle(null, 'ImageUrl');

                              setState(() {
                                _image = null;
                              });
                            },
                            //onPressed: null,
                          )
                        : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: userData.fname,
                      decoration: kTextFieldDecoration,
                      validator: (val) =>
                          val.isEmpty ? 'Please enter a first name' : null,
                      onChanged: (val) => setState(() => _currentFName = val),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      initialValue: userData.lname,
                      decoration: kTextFieldDecoration,
                      validator: (val) =>
                          val.isEmpty ? 'Please enter a last name' : null,
                      onChanged: (val) => setState(() => _currentLName = val),
                    ),
                    SizedBox(height: 20.0),
                    // dropdown example
                    //! Do not delete
                    // DropdownButtonFormField(
                    //   decoration: kTextFieldDecoration,
                    //   value: _currentDropdownSelection,
                    //   hint: Text('Select one or more'),
                    //   items: dropdownTest.map((item) {
                    //     return DropdownMenuItem(
                    //       value: item,
                    //       child: Text('$item'),
                    //     );
                    //   }).toList(),
                    //   onChanged: (val) =>
                    //       setState(() => _currentDropdownSelection = val),
                    // ),
                    //! ___________________________________________________________________
                    CheckboxListTile(
                      title: Text('Premium?'),
                      value: userData.issubscriber,
                      //selected: userData.issubscriber ?? false,
                      onChanged: (val) => setState(() {
                        _isSubscriber = val;
                        if (_formKey.currentState.validate()) {
                          UserDatabaseService(uid: user.uid)
                              .updateUserDataSingle(
                            _isSubscriber ?? userData.issubscriber,
                            'IsSubscribed',
                          );
                        }
                      }),
                    ),
                    ExpansionTile(
                      title: Text('Health Watch'),
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        TextFormField(
                          initialValue: userData.age.toString(),
                          keyboardType: TextInputType.number,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your age',
                          ),
                          onChanged: (val) => setState(() => _currentAge = val),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          initialValue: userData.weight.toString(),
                          keyboardType: TextInputType.number,
                          decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter your weight',
                          ),
                          onChanged: (val) =>
                              setState(() => _currentWeight = val),
                        ),
                      ],
                    ),

                    ExpansionTile(
                      title: Text('Health Labels'),
                      children: <Widget>[
                        CheckboxListTile(
                          title: Text('Vegan?'),
                          value: userData.vegan,
                          selected: userData.vegan ?? !userData.vegan,
                          onChanged: (val) => setState(() {
                            _vegan = val;
                            if (_formKey.currentState.validate()) {
                              UserDatabaseService(uid: user.uid)
                                  .updateUserDataSingle(
                                _vegan ?? userData.vegan,
                                'Vegan',
                              );
                            }
                          }),
                        ),
                        CheckboxListTile(
                          title: Text('Vegetarian?'),
                          value: userData.vegetarian,
                          selected: userData.vegetarian ?? !userData.vegetarian,
                          onChanged: (val) => setState(() {
                            _vegetarian = val;
                            if (_formKey.currentState.validate()) {
                              UserDatabaseService(uid: user.uid)
                                  .updateUserDataSingle(
                                _vegetarian ?? userData.vegetarian,
                                'Vegetarian',
                              );
                            }
                          }),
                        ),
                        CheckboxListTile(
                          title: Text('Lactose Free?'),
                          value: userData.lactosefree,
                          selected:
                              userData.lactosefree ?? !userData.lactosefree,
                          onChanged: (val) => setState(() {
                            _lactosefree = val;
                            if (_formKey.currentState.validate()) {
                              UserDatabaseService(uid: user.uid)
                                  .updateUserDataSingle(
                                _lactosefree ?? userData.lactosefree,
                                'LactoseFree',
                              );
                            }
                          }),
                        ),
                        CheckboxListTile(
                          title: Text('Keto?'),
                          value: userData.keto,
                          selected: userData.keto ?? !userData.keto,
                          onChanged: (val) => setState(() {
                            _keto = val;
                            if (_formKey.currentState.validate()) {
                              UserDatabaseService(uid: user.uid)
                                  .updateUserDataSingle(
                                _keto ?? userData.keto,
                                'Keto',
                              );
                            }
                          }),
                        ),
                        CheckboxListTile(
                          title: Text('Diabetes?'),
                          value: userData.diabetes,
                          selected: userData.diabetes ?? !userData.diabetes,
                          onChanged: (val) => setState(() {
                            _diabetes = val;
                            if (_formKey.currentState.validate()) {
                              UserDatabaseService(uid: user.uid)
                                  .updateUserDataSingle(
                                _diabetes ?? userData.diabetes,
                                'Diabetes',
                              );
                            }
                          }),
                        ),
                      ],
                    ),

                    ExpansionTile(
                      title: Text('Deactivate Account'),
                      children: <Widget>[
                        RoundedButton(
                          title: 'Delete',
                          color: Colors.red,
                          onPressed: () async {
                            //Delete the user document
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Alert'),
                                    content: Text(
                                        'are you certain you want to delete your account?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Delete'),
                                        onPressed: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyApp()));
                                          await UserDatabaseService(
                                                  uid: user.uid)
                                              .deleteUserData();
                                        },
                                      )
                                    ],
                                  );
                                });
                          },
                        )
                      ],
                    ),

                    RoundedButton(
                        color: Colors.pink,
                        title: 'Update',
                        onPressed: () async {
                          //! FOR TESTING__________________
                          print(_image);
                          // print(_currentFName);
                          // print(_currentLName);
                          // print('subscriber: $_isSubscriber');
                          // print(_currentDropdownSelection);
                          // print(_currentAge);
                          // print(_currentWeight);
                          // print(_vegetarian);
                          // print(_vegan);
                          // print(_lactosefree);
                          // print(_keto);
                          // print(_diabetes);
                          //print(_labels);
                          //! _____________________________
                          if (_formKey.currentState.validate()) {
                            await UserDatabaseService(uid: user.uid)
                                .updateUserData(
                                    userData.email,
                                    _currentFName ?? userData.fname,
                                    _currentLName ?? userData.lname,
                                    userData.id,
                                    _isSubscriber ?? userData.issubscriber,
                                    _currentAge ?? userData.age,
                                    _currentWeight ?? userData.weight,
                                    _vegan ?? userData.vegan,
                                    _vegetarian ?? userData.vegetarian,
                                    _lactosefree ?? userData.lactosefree,
                                    _keto ?? userData.keto,
                                    _diabetes ?? userData.diabetes,
                                    userData.favorites,
                                    _image !=null ? _image : _uploadedFileURL != null ? userData.imageurl : '');
                            // print('..................................');
                            // print(userData.email);
                            // print('..................................');
                            Navigator.pop(context);
                          }
                        }),
                  ],
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
