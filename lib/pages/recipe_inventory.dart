import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pantry_chef/models/grocery_ingredient.dart';
import 'package:pantry_chef/models/user.dart';
import 'package:pantry_chef/models/userIngredients.dart';
import 'package:pantry_chef/models/wasteIngredient.dart';
import 'package:pantry_chef/services/db_recipe_collection.dart';
import 'package:pantry_chef/services/db_user_collection.dart';
import 'package:pantry_chef/shared/loading.dart';
import 'package:pantry_chef/widgets/ingredient_text.dart';
import 'package:pantry_chef/style/styles.dart';
import 'package:provider/provider.dart';

class RecipeInventory extends StatefulWidget {
  @override
  _RecipeInventoryState createState() => _RecipeInventoryState();
}

class _RecipeInventoryState extends State<RecipeInventory> {
  final _formKey = GlobalKey<FormState>();

  var uomDropDown = [
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
  ];
  String dropdown;

  var _newResultList;

  List<Map<String, Object>> _addIngredient = [
    {
      'Description': '',
      'Quantity': '',
      'Price': '',
      'UoM': 'kg',
    }
  ];
  var _newIngredients;
  var ingredientName;
  List<Map<String, Object>> _newWaste = [];
  List<Map<String, Object>> wastetemplate = [];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var _streamdata = UserDatabaseService(uid: user.uid).userIngredient;

    return StreamBuilder<UserIngredient>(
        stream: _streamdata,
        builder: (context, snapshot) {
          UserIngredient userIngredient;

          if (snapshot.hasData) {
            userIngredient = snapshot.data;
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Loading();
          }

          if (userIngredient == null) {
            return Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                      Colors.lightGreenAccent[100],
                      Colors.lightBlueAccent[100]
                    ])),
                padding: EdgeInsets.all(14.0),
                child: Column(children: <Widget>[
                  Text(
                    'My Pantry',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('nothing in here yet...'),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: ListView.builder(
                          //shrinkWrap: true,
                          itemCount: _addIngredient.length,
                          itemBuilder: (context, int index) {
                            return Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    onChanged: (val) => setState(
                                      () => {
                                        _addIngredient[index]['Description'] =
                                            val,
                                      },
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Ingredient Name',
                                      hintStyle: TextStyle(
                                          fontStyle: FontStyle.italic),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                  child: new IconButton(
                                      icon: new Icon(
                                        Icons.attach_money,
                                      ),
                                      onPressed: null),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    onChanged: (val) => setState(
                                      () => {
                                        _addIngredient[index]['Price'] = val,
                                      },
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '0.00',
                                      hintStyle: TextStyle(
                                          fontStyle: FontStyle.italic),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 18.0),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    onChanged: (val) => setState(
                                      () => {
                                        _addIngredient[index]['Quantity'] = val,
                                      },
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Quantity',
                                      hintStyle: TextStyle(
                                          fontStyle: FontStyle.italic),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: DropdownButton(
                                    underline: SizedBox(),
                                    elevation: 3,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    //hint: Text('UoM'),
                                    value: _addIngredient[index][
                                        'UoM'], //breaks when I dont initialize the list, cannot set hint text to UoM
                                    onChanged: (value) {
                                      setState(() {
                                        _addIngredient[index]['UoM'] = value;
                                      });
                                    },
                                    items: uomDropDown.map((val) {
                                      return new DropdownMenuItem(
                                          value: val, child: new Text(val));
                                    }).toList(),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                  RoundedButton(
                    title: 'Add Ingredient',
                    color: Colors.deepOrangeAccent,
                    onPressed: () async {
                      //print(_addIngredient);
                      if (_formKey.currentState.validate()) {
                        await UserDatabaseService(uid: user.uid)
                            .addUserIngredient(
                          _addIngredient,
                        );
                      }
                    },
                  ),
                ]),
              ),
            );
          } else {
            //this if is crucial, if not the list doesnt get initialized, and you cant set state of the text form field

            if (_newIngredients == null) {
              userIngredient = snapshot.data;
              _newIngredients = [];
              _newIngredients.insertAll(0, userIngredient.ingredients);

              // final set = Set<GroceryIngredient>.from(
              //                         _newIngredients.map<GroceryIngredient>(
              //                             (item) => GroceryIngredient(
              //                                 item['Description'],
              //                                 item['Quantity'],
              //                                 item['UoM'])));

              //                     final result = set
              //                         .map((ingredient) => ingredient.toMap())
              //                         .toList();
              //                         print(result.runtimeType);

              //                         _newResultList = result;

            }

            //print(_newIngredients);
            return Form(
              key: _formKey,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                      Colors.lightBlueAccent[100],
                      Colors.lightGreenAccent[100],
                    ])),
                padding: EdgeInsets.all(14.0),
                child: Column(children: <Widget>[
                  Text(
                    'My Pantry',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userIngredient.ingredients.length,
                      itemBuilder: (context, int index) {
                        // _newIngredients[index]['Description'] = userIngredient.ingredients[index]['Description'];
                        // _newIngredients[index]['Quantity'] = userIngredient.ingredients[index]['Quantity'];
                        // _newIngredients[index]['UoM'] = userIngredient.ingredients[index]['UoM'];
                        return Row(
                          children: <Widget>[
                            Expanded(
                              flex: 7,
                                                          child: Container(
                                child: TextFormField(
                                  initialValue: _newIngredients[index]
                                          ['Description']
                                      .toString(),
                                  onChanged: (val) => setState(
                                    () => _newIngredients[index]['Description'] =
                                        val,
                                    //print(userIngredient.ingredients[index]['description']),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                              child: new IconButton(
                                  icon: new Icon(
                                    Icons.attach_money,
                                  ),
                                  onPressed: null),
                            ),
                            Expanded(
                              flex: 4,
                                                          child: Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 18.0),
                                  ),
                                  initialValue:
                                      _newIngredients[index]['Price'].toString(),
                                  onChanged: (val) => setState(
                                    () => {
                                      _newIngredients[index]['Price'] =
                                          double.parse(val),
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 40,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                initialValue: _newIngredients[index]['Quantity']
                                    .toString(),
                                onChanged: (val) => setState(
                                  () => {
                                    _newIngredients[index]['Quantity'] =
                                        double.parse(val),
                                  },
                                ),
                              ),
                            ),

                            Container(
                              width: 60,
                              child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    //alignedDropdown: true,
                                    child: DropdownButton(
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      elevation: 3,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      value: _newIngredients[index]['UoM'],
                                      onChanged: (val) => setState(
                                        () => {
                                          _newIngredients[index]['UoM'] = val,
                                          //print(_newIngredients),
                                        },
                                      ),
                                      items: uomDropDown.map((val) {
                                        return new DropdownMenuItem(
                                          value: val,
                                          child: new Text(val),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                            ),
                            IconButton(
                                icon: Icon(Icons.delete,),
                                onPressed: () async {
                                  ingredientName =
                                      _newIngredients[index]['Description'];
                                  //print(dropdown);

                                  //Delete the user ingredient
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Warning'),
                                          content: StatefulBuilder(
                                            builder: (context,
                                                StateSetter setState) {
                                              return Container(
                                                height: 100,
                                                child:
                                                    Column(children: <Widget>[
                                                  Text(
                                                      'are you certain you want to delete $ingredientName?'),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  DropdownButton(
                                                    hint: Text('Reason'),
                                                    elevation: 3,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        dropdown = val;
                                                        //print(dropdown);
                                                      });
                                                    },
                                                    value: dropdown,
                                                    items: <String>[
                                                      'Thrown Out',
                                                      'Used',
                                                      'Compost',
                                                      'Given Away',
                                                      'Other',
                                                    ].map((val) {
                                                      return new DropdownMenuItem(
                                                        value: val,
                                                        child: new Text(val),
                                                      );
                                                    }).toList(),
                                                  )
                                                ]),
                                              );
                                            },
                                          ),
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
                                                //print([index]);
                                                // _newWaste.add( _newIngredients+ '$dropdown');

                                                wastetemplate = [
                                                  {
                                                    'UoM':
                                                        _newIngredients[index]
                                                            ['UoM'],
                                                    'Description':
                                                        _newIngredients[index]
                                                            ['Description'],
                                                    'Price':
                                                        _newIngredients[index]
                                                            ['Price'],
                                                    'Quantity':
                                                        _newIngredients[index]
                                                            ['Quantity'],
                                                    'Reason': dropdown,
                                                    'DateDeleted':
                                                        Timestamp.now(),
                                                  }
                                                ];

                                                _newWaste.insertAll(
                                                    0, wastetemplate);

                                                //print(_newWaste);
                                                final set =
                                                    Set<WasteIngredient>.from(
                                                        _newWaste.map<
                                                            WasteIngredient>(
                                                  (item) => WasteIngredient(
                                                      item['Description'],
                                                      item['Quantity'],
                                                      item['Price'],
                                                      item['UoM'],
                                                      item['Reason'],
                                                      item['DateDeleted']),
                                                ));

                                                final result = set
                                                    .map((ingredient) =>
                                                        ingredient.toMap())
                                                    .toList();

                                                print(result);
                                                await UserDatabaseService(
                                                        uid: user.uid)
                                                    .deleteUserIngredient(
                                                  userIngredient
                                                      .ingredients[index],
                                                );
                                                await UserDatabaseService(
                                                        uid: user.uid)
                                                    .createWasteIngredient(
                                                        result);

                                                Navigator.of(context).pop();
                                              },
                                            )
                                          ],
                                        );
                                      });
                                }),
                          ],
                        );
                      },
                    ),
                  ),
                  RoundedButton(
                      title: ('Save'),
                      color: Colors.blue,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          //print(_newIngredients);
                          await UserDatabaseService(uid: user.uid)
                              .updateUserIngredients(
                            _newIngredients ?? userIngredient.ingredients,
                          );
                        }
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: ListView.builder(
                          //shrinkWrap: true,
                          itemCount: _addIngredient.length,
                          itemBuilder: (context, int index) {
                            return Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    onChanged: (val) => setState(
                                      () => {
                                        _addIngredient[index]['Description'] =
                                            val,
                                      },
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Ingredient Name',
                                      hintStyle: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                  child: new IconButton(
                                      icon: new Icon(
                                        Icons.attach_money,
                                      ),
                                      onPressed: null),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    //textAlign: TextAlign.end,
                                    onChanged: (val) => setState(
                                      () => {
                                        _addIngredient[index]['Price'] =
                                            double.parse(val),
                                      },
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '0.00',
                                      hintStyle: TextStyle(
                                          fontStyle: FontStyle.italic),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 18.0),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    onChanged: (val) => setState(
                                      () => {
                                        _addIngredient[index]['Quantity'] =
                                            double.parse(val),
                                      },
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Quantity',
                                      hintStyle: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: DropdownButton(
                                    elevation: 3,
                                    underline: SizedBox(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18),
                                    value: _addIngredient[index][
                                        'UoM'], //breaks when I dont initialize the list, cannot set hint text to UoM
                                    onChanged: (value) {
                                      setState(() {
                                        _addIngredient[index]['UoM'] = value;
                                      });
                                    },
                                    items: uomDropDown.map((val) {
                                      return new DropdownMenuItem(
                                          value: val, child: new Text(val));
                                    }).toList(),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                  RoundedButton(
                    title: 'Add Ingredient',
                    color: Colors.deepOrangeAccent,
                    onPressed: () async {
                      //print(_addIngredient);
                      if (_formKey.currentState.validate()) {
                        await UserDatabaseService(uid: user.uid)
                            .addUserIngredient(
                          _addIngredient,
                        );
                      }
                      //print(snapshot.data.ingredients);
                      setState(() {
                        _newIngredients = null;
                      });
                    },
                  ),
                ]),
              ),
            );
          }
        });
  }
}
