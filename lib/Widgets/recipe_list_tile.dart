import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import '../models/recipe.dart';
import '../models/user.dart';
import '../pages/home/recipe/recipe_details.dart';

class RecipeTile extends StatelessWidget {
  final Recipe recipe;
  final bool isFavorite;
  final UserData userData;
  final VoidCallback onPressed;

  const RecipeTile(
      {Key key, this.recipe, this.isFavorite, this.userData, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {

    String ingredientList = ''; 
    recipe.ingredients
                  .forEach((item) => {ingredientList += '\n${item}'});
    String shareMessage = 'Check out this recipe I found on Pantry Chef!'
    + '\n${recipe.title.toUpperCase()}'
    + '\n\n${recipe.description}'
    + '\n${ingredientList}';

    return Padding(
        padding: EdgeInsets.only(top: 4.0),
        child: Card(
          elevation: 5,
          margin: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
            height: 85.0,
            child: ListTile(
              //TODO: add a function for users to share recipes
              //*: as a user, I'd like to share recipes with my friends
              //TODO: if a user is the owner of this recipe, include an option for delete
              onLongPress: () => {
                print('This is recipe ID - ${recipe.recipeId}'),
                Share.share('${shareMessage.toString()}', subject: 'Food for Thought'),
              },
              leading: CircleAvatar(
                radius: 25.0,
                // if the recipe doesn't have an imageUrl, it will default
                // to a placeholder image
                backgroundImage: recipe.imageUrl != ''
                    ? NetworkImage(recipe.imageUrl)
                    : NetworkImage('https://via.placeholder.com/150'),
                backgroundColor: Colors.transparent,
              ),
              title: Text(recipe.title),
              subtitle: Text('Serves: ${recipe.servingSize}'),
              trailing: new FlatButton(
                // function to remove a favorited recipe from a user's list
                onPressed: onPressed,
                child: Column(
                  children: <Widget>[
                    // Check for matching favorite recipe using the current UID
                    //display the favorites as a red heart
                    Padding(padding: EdgeInsets.only(top: 8.0)),
                    new Icon(
                      isFavorite !=
                              (userData.favorites.contains(recipe.recipeId))
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isFavorite !=
                              (userData.favorites.contains(recipe.recipeId))
                          ? Colors.red
                          : null,
                    ),
                    Text('${recipe.likes}'),
                  ],
                ),
              ),
              onTap: () => {
                //!_________________________________________________
                //TODO: create a recipe page to view more information
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetails(recipe: recipe),
                  ),
                ),
              },
              //!_________________________________________________
            ),
          ),
        ));
  }
}