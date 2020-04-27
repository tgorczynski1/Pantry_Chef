import 'package:flutter/material.dart';
import 'package:pantry_chef/models/recipe.dart';
import 'package:pantry_chef/pages/home/recipe/recipe_list.dart';
import 'package:pantry_chef/services/db_recipe_collection.dart';
import 'package:provider/provider.dart';

class HomeRecipe extends StatefulWidget {
  @override
  _HomeRecipeState createState() => _HomeRecipeState();
}

class _HomeRecipeState extends State<HomeRecipe> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Recipe>>.value(
      value: RecipeDatabaseService().recipeInfo,
      child: 
         
        Column(
          children: <Widget>[
            Expanded(
              child: Container(
                //! ________________________________________________________________
                //TODO: Find a decent image to use as our background...
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.dstOut),
                    image: AssetImage('assets/img/pantry_chef_green.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                //! ________________________________________________________________
                // child: UserList()
                child: RecipeList(),
              ),
            ),
          ],
        ),
      
      );
  }
}