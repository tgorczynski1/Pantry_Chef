import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pantry_chef/models/grocery_ingredient.dart';
import 'package:pantry_chef/models/recipe.dart';
import 'package:pantry_chef/models/user.dart';
import 'package:pantry_chef/models/user_meal.dart';
import 'package:pantry_chef/pages/home/home.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:pantry_chef/services/db_user_collection.dart';
import 'package:pantry_chef/shared/loading.dart';
import 'package:pantry_chef/style/styles.dart';
import 'package:provider/provider.dart';

import 'grocery_list.dart';

class MealPlan extends StatefulWidget {
  @override
  _MealPlanState createState() => _MealPlanState();
}

class _MealPlanState extends State<MealPlan> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  // final Event event = Event(
  //   title: 'Event title',
  //   description: 'Event description',
  //   location: 'Event location',
  //   startDate: DateTime.now(),
  //   endDate: DateTime.now().add(Duration(days: 1)),
  //   allDay: false,
  // );

  String eventDescription = '';

  /*
  UserMeal
    String rid;
    String name;
  */
  List<UserMealPlan> userMeals;

  List<String> dayOfTheWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  List<Map<String, Object>> _newDayPlan = [
    {
      'Day': '',
    }
  ];
  // temp arrays for meals
  List<String> _breakfast = [];
  List<String> _lunch = [];
  List<String> _dinner = [];
  // dropdown items
  List<String> recipeNames = [];
  UserMealPlan userMealData;

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final recipe = Provider.of<List<Recipe>>(context) ?? [];
    recipeNames.length = recipe.length;
    _newDayPlan.length = 7;
    _breakfast.length = 7;
    _lunch.length = 7;
    _dinner.length = 7;

    for (var i = 0; i < recipe.length.toInt(); i++) {
      if (recipeNames[i] == null) {
        recipeNames[i] = recipe[i].title;
      }
      // print(i.toString());
      // print(recipeNames.toString());
    }

    for (var i = 0; i < _newDayPlan.length; i++) {
      _newDayPlan[i] = {'Day': ''};
    }

    // assign each day of the week
    _newDayPlan[0]['Day'] = this.dayOfTheWeek[0];
    _newDayPlan[1]['Day'] = this.dayOfTheWeek[1];
    _newDayPlan[2]['Day'] = this.dayOfTheWeek[2];
    _newDayPlan[3]['Day'] = this.dayOfTheWeek[3];
    _newDayPlan[4]['Day'] = this.dayOfTheWeek[4];
    _newDayPlan[5]['Day'] = this.dayOfTheWeek[5];
    _newDayPlan[6]['Day'] = this.dayOfTheWeek[6];

    // ensure that every index exists with at least a null value
    for (var i = 0; i < _newDayPlan.length.toInt(); i++) {
      if (_breakfast[i] == null) {
        _breakfast[i] = '';
      }
      if (_lunch[i] == null) {
        _lunch[i] = '';
      }
      if (_dinner[i] == null) {
        _dinner[i] = '';
      }
      // print(i.toString());
      // print(recipeNames.toString());
    }

    return StreamBuilder<UserMealPlan>(
      stream: UserDatabaseService(uid: user.uid).userMeals,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          userMealData = snapshot.data;
        }
        return StreamBuilder<UserData>(
          stream: UserDatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData userData = snapshot.data;

              return Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        //* clear variables for each form
                        String tempBreakfast;
                        String tempLunch;
                        String tempDinner;
                        return Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              alignment: Alignment.centerLeft,
                              color: Colors.grey,
                              child: RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                      text: dayOfTheWeek[index].toString())),
                            ),
                            ListTile(
                              title: Text(
                                  'Breakfast: \t\t ${_breakfast[index].isNotEmpty ? _breakfast[index] : userMealData.weekPlan[index]['Breakfast'].isNotEmpty ? userMealData.weekPlan[index]['Breakfast'].toString() : ''}'),
                              onTap: () {
                                print(
                                    'choose breakfast for ${userData.fname + ' ' + userData.lname} on ${this.dayOfTheWeek[index]}');
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: DropdownButton(
                                                hint: Text('Breakfast'),
                                                value: userMealData
                                                        .weekPlan[index]
                                                            ['Breakfast']
                                                        .isNotEmpty
                                                    ? userMealData
                                                            .weekPlan[index]
                                                        ['Breakfast']
                                                    : tempBreakfast,
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      tempBreakfast = value;
                                                    },
                                                  );
                                                },
                                                items: recipeNames.map(
                                                  (val) {
                                                    return new DropdownMenuItem(
                                                      value: val,
                                                      child: new Text(val),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextFormField(),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RaisedButton(
                                                child: Text("Save"),
                                                onPressed: () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    _formKey.currentState
                                                        .save();
                                                  }
                                                  setState(
                                                    () {
                                                      _breakfast[index] =
                                                          tempBreakfast;

                                                      _newDayPlan[index]
                                                              ['Breakfast'] =
                                                          _breakfast[index];
                                                    },
                                                  );
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                  'Lunch: \t\t ${_lunch[index].isNotEmpty ? _lunch[index] : userMealData.weekPlan[index]['Lunch'].isNotEmpty ? userMealData.weekPlan[index]['Lunch'].toString() : ''}'),
                              onTap: () {
                                print(
                                    'choose lunch for ${userData.fname + ' ' + userData.lname} on ${this.dayOfTheWeek[index]}');
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: DropdownButton(
                                                hint: Text('Lunch'),
                                                value: userMealData
                                                        .weekPlan[index]
                                                            ['Lunch']
                                                        .isNotEmpty
                                                    ? userMealData
                                                            .weekPlan[index]
                                                        ['Lunch']
                                                    : tempLunch,
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      tempLunch = value;
                                                    },
                                                  );
                                                },
                                                items: recipeNames.map(
                                                  (val) {
                                                    return new DropdownMenuItem(
                                                      value: val,
                                                      child: new Text(val),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextFormField(),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RaisedButton(
                                                child: Text("Save"),
                                                onPressed: () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    _formKey.currentState
                                                        .save();
                                                  }
                                                  setState(
                                                    () {
                                                      _lunch[index] = tempLunch;

                                                      _newDayPlan[index]
                                                              ['Lunch'] =
                                                          _lunch[index];
                                                    },
                                                  );
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            ListTile(
                              title: Text(
                                  'Dinner: \t\t ${_dinner[index].isNotEmpty ? _dinner[index] : userMealData.weekPlan[index]['Dinner'].isNotEmpty ? userMealData.weekPlan[index]['Dinner'].toString() : ''}'),
                              onTap: () {
                                print(
                                    'choose dinner for ${userData.fname + ' ' + userData.lname} on ${this.dayOfTheWeek[index]}');
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: DropdownButton(
                                                hint: Text('Dinner'),
                                                value: userMealData
                                                        .weekPlan[index]
                                                            ['Dinner']
                                                        .isNotEmpty
                                                    ? userMealData
                                                            .weekPlan[index]
                                                        ['Dinner']
                                                    : tempDinner,
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      tempDinner = value;
                                                    },
                                                  );
                                                },
                                                items: recipeNames.map(
                                                  (val) {
                                                    return new DropdownMenuItem(
                                                      value: val,
                                                      child: new Text(val),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: TextFormField(),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: RaisedButton(
                                                child: Text("Save"),
                                                onPressed: () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    _formKey.currentState
                                                        .save();
                                                  }
                                                  setState(
                                                    () {
                                                      _dinner[index] =
                                                          tempDinner;

                                                      _newDayPlan[index]
                                                              ['Dinner'] =
                                                          _dinner[index];
                                                    },
                                                  );
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                      width: double.infinity,
                      color: Colors.green[100],
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(right: 15.0),
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(28.0))),
                                child: Row(
                                  children: <Widget>[
                                    IconButton(
                                      color: Colors.white,
                                      icon: Icon(Icons.save),
                                      onPressed: () {
                                        print('save pressed');
                                      },
                                    ),
                                    Text('Save',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0)),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                print('save pressed');
                                // check for any changes in Breakfast, Lunch, and Dinner items
                                for (var i = 0; i < _newDayPlan.length; i++) {
                                  if (_breakfast[i].isNotEmpty) {
                                    // assign the new value
                                    _newDayPlan[i]['Breakfast'] = _breakfast[i];
                                    // assign the recipe Id
                                    recipe.forEach(
                                      (f) => {
                                        if (f.title == _breakfast[i])
                                          {
                                            _newDayPlan[i]['BreakfastId'] =
                                                f.recipeId,
                                          },
                                      },
                                    );
                                  } else {
                                    if (userMealData
                                        .weekPlan[i]['Breakfast'].isNotEmpty) {
                                      // keep the existing value from the database
                                      _newDayPlan[i]['Breakfast'] =
                                          userMealData.weekPlan[i]['Breakfast'];
                                      // assign the recipe Id
                                      recipe.forEach(
                                        (f) => {
                                          if (f.title ==
                                              userMealData.weekPlan[i]
                                                  ['Breakfast'])
                                            {
                                              _newDayPlan[i]['BreakfastId'] =
                                                  f.recipeId,
                                            },
                                        },
                                      );
                                    } else {
                                      // if no meal is selected, assign a placeholder
                                      _newDayPlan[i]['Breakfast'] = '';
                                      _newDayPlan[i]['BreakfastId'] = '';
                                    }
                                  }
                                  if (_breakfast[i].isNotEmpty) {
                                    // assign the new value
                                    _newDayPlan[i]['Breakfast'] = _breakfast[i];
                                    // assign the recipe Id
                                    recipe.forEach(
                                      (f) => {
                                        if (f.title == _breakfast[i])
                                          {
                                            _newDayPlan[i]['BreakfastId'] =
                                                f.recipeId,
                                          },
                                      },
                                    );
                                  } else {
                                    if (userMealData
                                        .weekPlan[i]['Breakfast'].isNotEmpty) {
                                      // keep the existing value from the database
                                      _newDayPlan[i]['Breakfast'] =
                                          userMealData.weekPlan[i]['Breakfast'];
                                      // assign the recipe Id
                                      recipe.forEach(
                                        (f) => {
                                          if (f.title ==
                                              userMealData.weekPlan[i]
                                                  ['Breakfast'])
                                            {
                                              _newDayPlan[i]['BreakfastId'] =
                                                  f.recipeId,
                                            },
                                        },
                                      );
                                    } else {
                                      // if no meal is selected, assign a placeholder
                                      _newDayPlan[i]['Breakfast'] = '';
                                      _newDayPlan[i]['BreakfastId'] = '';
                                    }
                                  }

                                  if (_lunch[i].isNotEmpty) {
                                    // assign the new value
                                    _newDayPlan[i]['Lunch'] = _lunch[i];
                                    // assign the recipe Id
                                    recipe.forEach(
                                      (f) => {
                                        if (f.title == _lunch[i])
                                          {
                                            _newDayPlan[i]['LunchId'] =
                                                f.recipeId,
                                          },
                                      },
                                    );
                                  } else {
                                    if (userMealData
                                        .weekPlan[i]['Lunch'].isNotEmpty) {
                                      // keep the existing value from the database
                                      _newDayPlan[i]['Lunch'] =
                                          userMealData.weekPlan[i]['Lunch'];
                                      // assign the recipe Id
                                      recipe.forEach(
                                        (f) => {
                                          if (f.title ==
                                              userMealData.weekPlan[i]['Lunch'])
                                            {
                                              _newDayPlan[i]['LunchId'] =
                                                  f.recipeId,
                                            },
                                        },
                                      );
                                    } else {
                                      // if no meal is selected, assign a placeholder
                                      _newDayPlan[i]['Lunch'] = '';
                                      _newDayPlan[i]['LunchId'] = '';
                                    }
                                  }

                                  if (_dinner[i].isNotEmpty) {
                                    // assign the new value
                                    _newDayPlan[i]['Dinner'] = _dinner[i];
                                    // assign the recipe Id
                                    recipe.forEach(
                                      (f) => {
                                        if (f.title == _dinner[i])
                                          {
                                            _newDayPlan[i]['DinnerId'] =
                                                f.recipeId,
                                          },
                                      },
                                    );
                                  } else {
                                    if (userMealData
                                        .weekPlan[i]['Dinner'].isNotEmpty) {
                                      // keep the existing value from the database
                                      _newDayPlan[i]['Dinner'] =
                                          userMealData.weekPlan[i]['Dinner'];
                                      // assign the recipe Id
                                      recipe.forEach(
                                        (f) => {
                                          if (f.title ==
                                              userMealData.weekPlan[i]
                                                  ['Dinner'])
                                            {
                                              _newDayPlan[i]['DinnerId'] =
                                                  f.recipeId,
                                            },
                                        },
                                      );
                                    } else {
                                      // if no meal is selected, assign a placeholder
                                      _newDayPlan[i]['Dinner'] = '';
                                      _newDayPlan[i]['DinnerId'] = '';
                                    }
                                  }

                                  // print(_newDayPlan[i]);
                                  // print(userMealData.weekPlan[i]);

                                }

                                // print(groceryList);
                                UserDatabaseService(uid: user.uid)
                                    .updateUserMeal(_newDayPlan);
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(right: 15.0),
                              child: RoundedButton(
                                color: Colors.black38,
                                title: 'Add Reminder',
                                onPressed: () {
                                  Add2Calendar.addEvent2Cal(
                                    Event(
                                      title: 'Meal Plan',
                                      description: eventDescription,
                                      location: 'Event location',
                                      startDate: DateTime.now(),
                                      endDate: DateTime.now().add(
                                        Duration(days: 1),
                                      ),
                                      allDay: false,
                                    ),
                                  ).then(
                                    (success) {
                                      scaffoldState.currentState.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              success ? 'Success' : 'Error'),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: RoundedButton(
                                color: Colors.black38,
                                title: 'Grocery List',
                                onPressed: () {
                                  //TODO: compile a list of ingredients for the week
                                  //! compare the users ingredients on-hand to the required amount
                                  // print('get grocery list');

                                  List<dynamic> _finalGroceryList = [];
                                  List<dynamic> _groceryList = [];

                                  var _breakfastIngredients = [];
                                  var _lunchIngredients = [];
                                  var _dinnerIngredients = [];

                                  // create a grocery list based on the recipe Id
                                  for (var i = 0;
                                      i < userMealData.weekPlan.length;
                                      i++) {
                                    if (userMealData.weekPlan[i]['BreakfastId']
                                        .isNotEmpty) {
                                      for (var r = 0; r < recipe.length; r++) {
                                        if (recipe[r].recipeId ==
                                            userMealData.weekPlan[i]
                                                ['BreakfastId']) {
                                          // add ingredients for day [i]
                                          _breakfastIngredients.insertAll(
                                              i, recipe[r].ingredients);
                                        }
                                      }
                                    }
                                    if (userMealData
                                        .weekPlan[i]['LunchId'].isNotEmpty) {
                                      for (var r = 0; r < recipe.length; r++) {
                                        if (recipe[r].recipeId ==
                                            userMealData.weekPlan[i]
                                                ['LunchId']) {
                                          // add ingredients for day [i]
                                          _lunchIngredients.insertAll(
                                              i, recipe[r].ingredients);
                                        }
                                      }
                                    }
                                    if (userMealData
                                        .weekPlan[i]['DinnerId'].isNotEmpty) {
                                      for (var r = 0; r < recipe.length; r++) {
                                        if (recipe[r].recipeId ==
                                            userMealData.weekPlan[i]
                                                ['DinnerId']) {
                                          // add ingredients for day [i]
                                          _dinnerIngredients.insertAll(
                                              i, recipe[r].ingredients);
                                        }
                                      }
                                    }
                                  }

                                  // add all breakfast, lunch, and dinner ingredients into one list
                                  _groceryList.insertAll(
                                      0, _breakfastIngredients);
                                  _groceryList.insertAll(0, _lunchIngredients);
                                  _groceryList.insertAll(0, _dinnerIngredients);

                                  //TODO: compare each ingredient in the groceryList and add duplicate's quantity together

                                  int quantityTest = 0;

                                  List<Map<String, Object>>
                                      ingredientsTemplate = [];
                                  List<Map<String, Object>> _newGroceryList =
                                      [];

                                  // *this is the count of items in the groceryList
                                  int indexCount = 0;

                                  _groceryList.forEach((f) {
                                    // set an index count for ingredient length
                                    indexCount++;
                                  });
                                  for (var i = 0; i < indexCount; i++) {
                                    var duplicateIngredients =
                                        _groceryList.where((ingredient) =>
                                            ingredient['Description'] ==
                                            _groceryList[i]['Description']);
                                    // *this will determine the multiplier value for the new quantity if duplicates exist
                                    // print(duplicateIngredients.length);
                                    if (duplicateIngredients.length > 1) {
                                      //TODO: create a new object with the new quantity and add it to a final list
                                      // print(duplicateIngredients);

                                      // *the length is the multiplier
                                      // print(duplicateIngredients.length);

                                      // *this is the item to multiply
                                      // print(_groceryList[i]);

                                      ingredientsTemplate = [
                                        {
                                          'UoM': _groceryList[i]['UoM'],
                                          'Description': _groceryList[i]
                                              ['Description'],
                                          'Quantity':
                                              (duplicateIngredients.length *
                                                  _groceryList[i]['Quantity'])
                                        }
                                      ];
                                      // ingredientsTemplate[0]['Description'] = _groceryList[i]['Description'];
                                      // ingredientsTemplate[0]['Quantity'] = (duplicateIngredients.length) * _groceryList[i]['Quantity'];

                                      _newGroceryList.insertAll(
                                          0, ingredientsTemplate);
                                    } else {
                                      //TODO: add the ingredient to a final list
                                      // print(duplicateIngredients);
                                      ingredientsTemplate = [
                                        {
                                          'UoM': _groceryList[i]['UoM'],
                                          'Description': _groceryList[i]
                                              ['Description'],
                                          'Quantity': (_groceryList[i]
                                              ['Quantity'])
                                        }
                                      ];
                                      // ingredientsTemplate[0]['Description'] = _groceryList[i]['Description'];
                                      // ingredientsTemplate[0]['Quantity'] = (duplicateIngredients.length) * _groceryList[i]['Quantity'];

                                      _newGroceryList.insertAll(
                                          0, ingredientsTemplate);
                                      // _newGroceryList.insertAll(0, duplicateIngredients);
                                    }
                                  }

                                  // *displays the current grocery list with duplicate items
                                  // print(_newGroceryList.toSet().toList());
                                  // *displays the variable type
                                  // print(_newGroceryList.runtimeType);

                                  final set = Set<GroceryIngredient>.from(
                                      _newGroceryList.map<GroceryIngredient>(
                                          (item) => GroceryIngredient(
                                              item['Description'],
                                              item['Quantity'],
                                              item['UoM'])));

                                  final result = set
                                      .map((ingredient) => ingredient.toMap())
                                      .toList();

                                  // *This is the final grocery List with duplicates removed
                                  // print(result.toSet());

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          GroceryList(list: result),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Loading();
            }
          },
        );
      },
    );
  }
}
