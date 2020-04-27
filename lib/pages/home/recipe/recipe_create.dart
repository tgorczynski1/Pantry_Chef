import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pantry_chef/models/user.dart';
import 'package:pantry_chef/services/db_recipe_collection.dart';
import 'package:pantry_chef/services/db_user_collection.dart';
import 'package:pantry_chef/shared/loading.dart';
import 'package:pantry_chef/style/styles.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart';

class RecipeForm extends StatefulWidget {
  @override
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  final _formKey = GlobalKey<FormState>();
  String _authorId;
  int _calories;
  List<String> _category;
  String _description;
  int _durationInMin;
  //!_______________________________________________
  //! This is for adding ingredients
  //! ----   List<Map<String, Object>>   ----

  //* this is initializing the ingredients with default values
  List<Map<String, Object>> _newIngredients = [
    {'Description': '', 'Quantity': '', }
  ];
  //!_______________________________________________

  List<String> _instructions = [''];
  bool _isRecipe = true;
  Map<String, bool> _labels;
  int _likes;
  int _servingSize;
  String _title;
  String _recipeId;
  File _image;
  String _imageUrl;
  String _uploadedFileURL;
  //String dropdownvalue = 'UoM';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: UserDatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //Map<String, bool> _hlabels = userData.labels;
            //print(_hlabels);
            //print(userData.vegan);

            Future getImage() async {
              await ImagePicker.pickImage(source: ImageSource.gallery)
                  .then((image) {//maybe need to switch the .then 
                setState(() {
                  _image = image;
                  //print('asd' + _image.toString());
                });
              });
            }

            void clearSelection() {
              setState(() {
                _image = null;
                _uploadedFileURL = null;
              });
            }

            return Form(
              key: _formKey,
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 25.0,
                    ),
                    Text(
                      'Create a New Recipe',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    
                    _image != null
                        ? Image.file(_image)
                        : Container(height: 150),
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
                             onPressed: clearSelection,
                            //onPressed: null,
                          )
                        : Container(),
                    _uploadedFileURL != null
                        ? Image.network(
                            _uploadedFileURL,
                            height: 150,
                          )
                        : Container(),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: ('Recipe title')),
                      onChanged: ((val) => setState(() => _title = val)),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      maxLines: 6,
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: ('Description')),
                      onChanged: (val) => setState(() => _description = val),
                    ),
                    // This element displays ingredients in a dropdown, that will increment textformfields when a button is pressed
                    ExpansionTile(
                      title: Text('Ingredients'),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(
                                  height: 200.0,
                                  child: new ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _newIngredients.length,
                                    itemBuilder: (context, int index) {
                                      return Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                // border: InputBorder.none,
                                                hintText:
                                                    'Ingredient ${index + 1}',
                                              ),
                                              initialValue:
                                                  _newIngredients[index]
                                                          ['Description']
                                                      .toString(),
                                              onChanged: (val) => setState(
                                                () => {
                                                  _newIngredients[index]
                                                      ['Description'] = val,
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                // border: InputBorder.none,
                                                hintText: 'Quantity',
                                              ),
                                              initialValue:
                                                  _newIngredients[index]
                                                          ['Quantity']
                                                      .toString(),
                                              onChanged: (val) => setState(
                                                () => {
                                                  _newIngredients[index]
                                                          ['Quantity'] =
                                                      int.parse(val),
                                                },
                                              ),
                                            ),
                                          ),

                                          //is it possible to populate dropdown from user input in description? ie milk => liquid => ml/pint
                                          //maybe too advanced of a feature for a non-integral part of the app
                                          Expanded(
                                            child: DropdownButton(
                                              hint: Text('UoM'),
                                              value: _newIngredients[index]['UoM'],
                                              onChanged: (value) {
                                                setState(() {
                                                  _newIngredients[index]['UoM'] = value;
                                                  //dropdownvalue = value;
                                                  //print(_newIngredients[index]);
                                                  //print(dropdownvalue);
                                                });
                                              },
                                              items: <String>[
                                                'c',
                                                'g',
                                                'kg',
                                                'L',
                                                'lb',
                                                'ml',
                                                'oz',
                                                'pt',
                                                'tsp',
                                                'Tbsp',
                                                'item'
                                              ].map((val) {
                                                return new DropdownMenuItem(
                                                    value: val,
                                                    child: new Text(val));
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              new IconButton(
                                icon: Icon(Icons.add_circle),
                                onPressed: () {
                                  setState(() {
                                    _newIngredients.add({
                                      'Description': '',
                                      'Quantity': '',
                                      // 'UoM': ''
                                    });
                                    //print(_newIngredients);
                                  });
                                },
                              ),
                              new IconButton(
                                //Use key property or index of object to delete specific row
                                icon: Icon(Icons.remove_circle),
                                onPressed: () {
                                  setState(() {
                                    _newIngredients.removeLast();
                                  });
                                },
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ),
                      ],
                    ),
                    //!_________________________________________________________________
                    SizedBox(height: 10.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: ('Calories')),
                      onChanged: (val) =>
                          setState(() => _calories = int.parse(val)),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: kTextFieldDecoration.copyWith(
                          labelText: ('Duration in Minutes')),
                      onChanged: (val) =>
                          setState(() => _durationInMin = int.parse(val)),
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: kTextFieldDecoration.copyWith(
                          //here add serving size
                          labelText: ('Serving Size (Adult)')),
                      onChanged: (val) =>
                          setState(() => _servingSize = int.parse(val)),
                    ),
                    // This element is a text form field that increments by a button
                    ExpansionTile(
                      title: Text('Instructions'),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(
                                  height: 200.0,
                                  child: new ListView.builder(
                                    //key:
                                    itemCount: _instructions.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 4.0, 0, 0),
                                        child: Column(
                                          children: <Widget>[
                                            new TextFormField(
                                                //key: Key(_instructions[index]), this allows to delete a correct item, but does not allow multiple characters into a string
                                                //TODO: Use key so you can individually delete text form fields
                                                initialValue:
                                                    _instructions[index]
                                                        .toString(),
                                                decoration: kTextFieldDecoration
                                                    .copyWith(
                                                        labelText:
                                                            ('Step ${index + 1}')),
                                                onChanged: (val) => setState(
                                                      () => {
                                                        // print('${index}'),
                                                        _instructions[index] =
                                                            val,
                                                        // print(
                                                        //     '${_instructions[index]}'),
                                                      },
                                                    )),
                                            // new IconButton( try updating key in setState
                                            //   icon: Icon(Icons.remove_circle),
                                            //   onPressed: () {
                                            //     setState(() {
                                            //       //String removedItem = _instructions.removeAt(index);
                                            //       //_instructions.removeWhere((val) => val == (index).toString()); doesnt work
                                            //       //_instructions.asMap();
                                            //       _instructions.removeAt(
                                            //           index); //works but only last item
                                            //       //print(removedItem);
                                            //     });
                                            //   },
                                            // ),
                                          ],
                                        ),
                                      );
                                      // return new Text(list[index]);
                                    },
                                  ),
                                ),
                              ),
                              new IconButton(
                                icon: Icon(Icons.add_circle),
                                onPressed: () {
                                  setState(() {
                                    _instructions.add('');
                                  });
                                },
                              ),
                              new IconButton(
                                icon: Icon(Icons.remove_circle),
                                onPressed: () {
                                  setState(() {
                                    _instructions
                                        .removeLast(); //unable to target a list item to delete
                                    //print('${[index]}');
                                  });
                                },
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ),
                      ],
                    ),
                    RoundedButton(
                        color: Colors.blueGrey,
                        title: 'Create Recipe',
                        onPressed: () async {
                          //await uploadFile(_image);


                          if (_formKey.currentState.validate()) {
                            //TODO: assign the strings or other Map Objects to the _newIngredients List
                            await RecipeDatabaseService().createRecipeData(
                              user.uid,
                              _calories ?? 0,
                              _description ?? '',
                              _durationInMin ?? 0,
                              _newIngredients,
                              _instructions,
                              _isRecipe,
                              _likes ?? 0,
                              _servingSize ?? 0,
                              _title ?? '',
                              _image ?? '',
                            );
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
