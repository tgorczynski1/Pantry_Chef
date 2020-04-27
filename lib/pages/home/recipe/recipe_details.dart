import 'package:flutter/material.dart';
import 'package:pantry_chef/models/recipe.dart';
import 'package:pantry_chef/models/user.dart';
import 'package:pantry_chef/models/userIngredients.dart';
import 'package:pantry_chef/pages/grocery_list.dart';
import 'package:pantry_chef/services/db_recipe_collection.dart';
import 'package:pantry_chef/services/db_user_collection.dart';
import 'package:pantry_chef/shared/loading.dart';
import 'package:pantry_chef/style/styles.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class RecipeDetails extends StatelessWidget {
  final Recipe recipe;

  // In the constructor, require a Recipe.
  RecipeDetails({Key key, @required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // Use the Recipe to create the UI.
    var myIngredients = [];
    var _updatedList = [];
    var ingredientData = recipe.ingredients;
    var list = [];
    int indexToRemove;
    List<String> ingredients = [];

    bool canMake = true;
    list.insertAll(0, ingredientData);

    // test for data
    for (var i = 0; i < ingredientData.length; i++) {
      String tempString = '';
      tempString = '\n${ingredientData[i]['Quantity']} ' +
          '${ingredientData[i]['UoM']} ' +
          '- ${ingredientData[i]['Description']}';
      ingredients.add(tempString);
    }

    String shareMessage = 'Check out this recipe I found on Pantry Chef!' +
        '\n${recipe.title.toUpperCase()}' +
        '\n\n${recipe.description}' +
        '${ingredients}';


    return StreamBuilder<UserIngredient>(
        stream: UserDatabaseService(uid: user.uid).userIngredient,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserIngredient userIngredient = snapshot.data;

            if (userIngredient.ingredients != null) {
              myIngredients = userIngredient.ingredients;
              // print(myIngredients);
            }
            myIngredients.forEach((f) {
              if (f['Description'].isNotEmpty) {
                for (var i = 0; i < list.length; i++) {
                  if ((list[i]['Description'] == f['Description']) &&
                      (list[i]['UoM'] == f['UoM'])) {
                    if ((f['Quantity'] == list[i]['Quantity']) ||
                        (f['Quantity'] > list[i]['Quantity'])) {
                      list[i]['Quantity'] = list[i]['Quantity'] - f['Quantity'];
                      if ((list[i]['Quantity'] == 0) ||
                          (list[i]['Quantity'] < 0)) {
                        // print('enough ingredients on hand for ' + list[i]['Description']);
                        indexToRemove = i;
                        list[i]['Description'] = '';
                        list[i]['Quantity'] = '';
                        list[i]['UoM'] = '';
                      }
                    } else {
                      list[i]['Quantity'] = list[i]['Quantity'] - f['Quantity'];
                    }
                  }
                }
                // print(f['Quantity'].runtimeType);
              }
            });
            _updatedList = list;
            // print(indexToRemove);
            if (indexToRemove != null) {
              _updatedList.removeAt(indexToRemove);
            }

            // set the bool to false if the user doesnt have the required ingredients
            list.forEach((f) {
              if (!(f['Quantity'] == '' || f['Quantity'] == null)) {
                canMake = false;
              }
            });

            return StreamBuilder<Recipe>(
                stream: RecipeDatabaseService(rid: recipe.recipeId)
                    .singleIngredient,
                builder: (context, recipesnapshot) {
                  Recipe testingIngredient = recipesnapshot.data;
                  // print(testingIngredient.ingredients);

                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.green,
                      title: Text(
                        recipe.title,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w900,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                    body: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 300,
                                      color: Colors.white,
                                    ),
                                    Center(
                                      child: Container(
                                        height: 240,
                                        width: double.infinity,
                                        child: Image.network(recipe.imageUrl,
                                            fit: BoxFit.fitWidth),
                                      ),
                                    ),
                                    Positioned(
                                        top: 215,
                                        left: 20,
                                        child: canMake
                                            ? RaisedButton(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(Icons.play_arrow),
                                                    Text('Make Now'),
                                                  ],
                                                ),
                                                color: Colors.lime,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                onPressed: () {
                                                  //? if the User confirms, remove the required recipe ingredients from their pantry
                                                  //TODO: create a confirmation prompt
                                                  //TODO: create a function which removes ingredients from the users' pantry
                                                  
                                                  print(testingIngredient.ingredients);

                                                  // calculateIngredients(myIngredients, recipe.recipeId);
                                                  // print(calculateList);
                                                })
                                            : RaisedButton(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(Icons.shopping_basket),
                                                    Text(' Grocery List'),
                                                  ],
                                                ),
                                                color: Colors.yellow[300],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          GroceryList(
                                                              list: list),
                                                    ),
                                                  );
                                                })),
                                    Positioned(
                                        top: 260,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              25.0, 8.0, 8.0, 8.0),
                                          child: Row(
                                            children: <Widget>[
                                              canMake
                                                  ? Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                    )
                                                  : Icon(
                                                      Icons.info,
                                                      color: Colors.blue,
                                                    ),
                                              canMake
                                                  ? Text(
                                                      '\t\tYou have all the required ingredients.',
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  : Text(
                                                      '\t\tSome required ingredients are missing.',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.lightBlue,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                            ],
                                          ),
                                        )),
                                    Positioned(
                                        top: 215,
                                        right: 20,
                                        child: RaisedButton(
                                            child: Text('Share'.toUpperCase()),
                                            color: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)),
                                            onPressed: () {
                                              // Share this recipe
                                              // print('Share This Recipe Pressed');
                                              Share.share(
                                                  '${shareMessage.toString().replaceAll('[', '').replaceAll(']', '')}',
                                                  subject: 'Food for Thought');
                                            })),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                ),
                                // description
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      width: 20,
                                      color: Colors.brown,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 3, 8, 3),
                                        child: Card(
                                            color: Colors.brown[100],
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 23.0, 8.0, 8.0),
                                              child: Text(
                                                recipe.description,
                                                style: TextStyle(fontSize: 17),
                                              ),
                                            )),
                                      ),
                                    ),
                                    Positioned(
                                        top: 5,
                                        left: 15,
                                        child: Text('Description',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18))),
                                  ],
                                ),
                                // ingredients
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      width: 20,
                                      color: Colors.lightBlue,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 3, 8, 3),
                                        child: Card(
                                          color: Colors.blue[100],
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 12.0, 8.0, 8.0),
                                            child: Column(
                                              children: ingredients
                                                  .map((item) => Row(
                                                        children: <Widget>[
                                                          new Expanded(
                                                            child: Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            45.0),
                                                                child:
                                                                    Text(item),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 5,
                                        left: 15,
                                        child: Text('Ingredients',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18))),
                                  ],
                                ),
                                // instructions
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      width: 20,
                                      color: Colors.green,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 3, 8, 3),
                                        child: Card(
                                          color: Colors.green[100],
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8.0, 18.0, 8.0, 8.0),
                                            child: Column(
                                              children: recipe.instructions
                                                  .map((item) => Row(
                                                        children: <Widget>[
                                                          new Expanded(
                                                            child: Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            0),
                                                                child: Text(
                                                                  item,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                  .toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: 5,
                                        left: 15,
                                        child: Text('Steps',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18))),
                                  ],
                                ),
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 20,
                                      width: 20,
                                      color: Colors.black,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 3, 8, 3),
                                        child: Card(
                                            color: Colors.black54,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 28.0, 8.0, 8.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          'Minutes',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .grey[300]),
                                                        ),
                                                        Icon(
                                                          Icons.timer,
                                                          size: 40,
                                                          color: Colors.white,
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            recipe.durationInMin
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          'Calories',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .grey[300]),
                                                        ),
                                                        Icon(
                                                          Icons.filter_list,
                                                          size: 40,
                                                          color: Colors.white,
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            recipe.calories
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        Text(
                                                          'Serves',
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .grey[300]),
                                                        ),
                                                        Icon(
                                                          Icons.fastfood,
                                                          size: 40,
                                                          color: Colors.white,
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            recipe.servingSize
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                    Positioned(
                                        top: 5,
                                        left: 15,
                                        child: Text('Information',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else
            return Loading();
        });
  }

  // calculateIngredients (var myIngredients, var recipeId){
  //   var id;
  //   id = recipeId;
  //   print(id);
  // }
}
