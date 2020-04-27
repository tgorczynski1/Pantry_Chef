import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pantry_chef/widgets/recipe_list_tile.dart';
import 'package:pantry_chef/models/user.dart';
import 'package:pantry_chef/services/db_recipe_collection.dart';
import 'package:pantry_chef/services/db_user_collection.dart';
import 'package:pantry_chef/shared/loading.dart';
import 'package:pantry_chef/style/styles.dart';
import 'package:provider/provider.dart';
import '../../../models/recipe.dart';

class RecipeList extends StatefulWidget {
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  List<bool> isFavorite = [];

  //* This is for the search filter
  TextEditingController controller = new TextEditingController();
  String filter;
  bool favFilter = false;

  @override
  initState() {
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final recipe = Provider.of<List<Recipe>>(context) ?? [];

    isFavorite.length = recipe.length;
    for (var i = 0; i < recipe.length.toInt(); i++) {
      if (isFavorite[i] == null) {
        isFavorite[i] = false;
      }
    }

    return Container(
      child: Column(
        children: <Widget>[
          //! _________________________________________
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: frostedRound(
                TextField(
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.withOpacity(0.6),
                    border: InputBorder.none,
                    hintText: "Search",
                    filled: true,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(Icons.search),
                  ),
                  //* this is the controller for the search filter
                  controller: controller,
                ),
              ),
            ),
          ),
          //TODO: Create filter toggles
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.favorite),
                  label: Text(''),
                  onPressed: () => {
                    setState(() {
                      if (filter != '*fav') {
                        filter = '*fav';
                      } else {
                        filter = '';
                      }
                      favFilter = !favFilter;
                    }),
                  },
                ),
                FlatButton.icon(
                  icon: Icon(Icons.access_alarm),
                  label: Text(''),
                  onPressed: () => () {},
                ),
                FlatButton.icon(
                  icon: Icon(Icons.access_alarm),
                  label: Text(''),
                  onPressed: () => () {},
                ),
                FlatButton.icon(
                  icon: Icon(Icons.access_alarm),
                  label: Text(''),
                  onPressed: () => () {},
                ),
              ],
            ),
          ),
          //! _________________________________________
          Expanded(
            child: Container(
              child: StreamBuilder<UserData>(
                stream: UserDatabaseService(uid: user.uid).userData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserData userData = snapshot.data;
                    return ListView.builder(
                      itemCount: recipe.length,
                      itemBuilder: (context, int index) {
                        return filter == null || filter == ''
                            ? new RecipeTile(
                                recipe: recipe[index],
                                isFavorite: isFavorite[index],
                                userData: userData,
                                onPressed: () =>
                                    onPressed(userData, recipe[index], user),
                              )
                            // : recipe[index]
                            //     .servingSize
                            //     .toString()
                            //     .contains(filter)
                            // ? new Text(recipe[index].title) :
                            : recipe[index]
                                    .title
                                    .toLowerCase()
                                    .contains(filter.toLowerCase())
                                ? new RecipeTile(
                                    recipe: recipe[index],
                                    isFavorite: isFavorite[index],
                                    userData: userData,
                                    onPressed: () => onPressed(
                                        userData, recipe[index], user),
                                  )
                                : userData.favorites
                                            .contains(recipe[index].recipeId) &&
                                        favFilter &&
                                        (filter == '*fav')
                                    ? new RecipeTile(
                                        recipe: recipe[index],
                                        isFavorite: isFavorite[index],
                                        userData: userData,
                                        onPressed: () => onPressed(
                                            userData, recipe[index], user),
                                      )
                                    : new Container();
                      },
                    );
                  } else {
                    return Loading();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  onPressed(userData, recipe, user) {
    setState(() {
      if (!userData.favorites.contains(recipe.recipeId)) {
        UserDatabaseService(uid: user.uid).updateUserDataSingle(
          FieldValue.arrayUnion(['${recipe.recipeId}']),
          'Favorites',
        );
        RecipeDatabaseService(rid: recipe.recipeId).updateRecipeDataSingle(
            recipe.recipeId, (recipe.likes + 1), 'Likes');
      } else {
        UserDatabaseService(uid: user.uid).updateUserDataSingle(
          FieldValue.arrayRemove(['${recipe.recipeId}']),
          'Favorites',
        );
        RecipeDatabaseService(rid: recipe.recipeId).updateRecipeDataSingle(
            recipe.recipeId, (recipe.likes - 1), 'Likes');
      }
    });
  }
}
