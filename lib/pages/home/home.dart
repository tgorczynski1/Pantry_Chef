import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pantry_chef/models/recipe.dart';
import 'package:pantry_chef/pages/feedback.dart';
import 'package:pantry_chef/pages/home/testing/object_map_test.dart';
import 'package:pantry_chef/pages/home/recipe/recipe_create.dart';
import 'package:pantry_chef/pages/home/recipe/recipe_list.dart';
import 'package:pantry_chef/pages/home/user/settings_form.dart';
import 'package:pantry_chef/pages/home/testing/ocr_test.dart';
import 'package:pantry_chef/pages/home_recipes.dart';
import 'package:pantry_chef/pages/recipe_inventory.dart';
import 'package:pantry_chef/pages/schedule_meal.dart';
import 'package:pantry_chef/pages/testfeedback.dart';
import 'package:pantry_chef/pages/waste.dart';
import 'package:pantry_chef/services/auth.dart';
import 'package:pantry_chef/services/db_recipe_collection.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:pantry_chef/pages/home/testing/object_map_test.dart';
import 'package:pantry_chef/pages/home_recipes.dart';



class Home extends StatefulWidget {
  @override
  State createState() => new HomeState();
}

class HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _selectedPage = 0;
  final _pageOptions = [
      HomeRecipe(),
      RecipeInventory(),
      WasteManagement(),
      MealPlan(),
      // FeedbackForm(),
      MyFeedback(),
    ];


  @override
  Widget build(BuildContext context) {
  // final String assetName = 'assets/img/PantryChef-Logo.svg';
  // final Widget svg = SvgPicture.asset(
  //   assetName,
  //   semanticsLabel: 'Pantry Chef Logo'
  // );
  // SvgPicture svgLogo = SvgPicture.string('<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 38.95 28.35"><defs><style>.cls-1,.cls-2{fill:none;stroke:#231f20;stroke-miterlimit:10;}.cls-1{stroke-width:0.25px;}.cls-2{stroke-width:2px;}.cls-3{font-size:5.1px;fill:#231f20;font-family:Arial-ItalicMT, Arial;font-style:italic;}.cls-4{fill:#78c147;}.cls-5{fill:#97ca4a;}</style></defs><g id="Logo"><g id="Black_Rings" data-name="Black Rings"><ellipse class="cls-1" cx="13.82" cy="13.48" rx="13.69" ry="13.35"/><ellipse class="cls-1" cx="13.81" cy="13.29" rx="11.79" ry="11.67"/><ellipse class="cls-2" cx="15" cy="14.58" rx="12.8" ry="12.58"/></g><text class="cls-3" transform="translate(8.82 18.84)">Chef</text><text class="cls-3" transform="translate(7.19 14.64)">Pantry</text><g id="Leaf"><path class="cls-4" d="M27,23.57c-3.23,1.59-5,5.88-3.65,8s5.59,2.22,9.61-.36a15.69,15.69,0,0,0,6.74-8.58C36.6,22.19,31.28,21.49,27,23.57Z" transform="translate(-0.73 -4.8)"/><path class="cls-5" d="M21.94,25.82c-.64,2.53.77,6.41,2.7,6.66s3.83-2.35,4.27-5.78-.84-5.51-2.09-7.5A14.19,14.19,0,0,0,21.94,25.82Z" transform="translate(-0.73 -4.8)"/></g></g></svg>', width: 35,);


    void _showForm(String text) {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter state) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
                child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    switch (text) {
                      case 'settings':
                        return SettingsForm();
                      case 'addRecipe':
                        //!_____________________________________
                        //TODO: added reference to RecipeForm()
                        //print('RecipeForm();');
                        return RecipeForm();
                        //!_____________________________________
                        break;
                      default:
                        return null;
                    }
                  },
                ),
              );
            });
          });
    }

    return StreamProvider<List<Recipe>>.value(
      value: RecipeDatabaseService().recipeInfo,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Colors.green,
          elevation: 0.0,
          actions: <Widget>[
            //!_______________________________________
            //! TEST PAGE TO DISPLAY MAP VARIABLES
            FlatButton.icon(
              icon: Icon(Icons.branding_watermark),
              // icon: svgLogo,
              label: Text(''),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OCRTest(),
                  ),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ObjectMapTest(),
                //   ),
                // );
              },
            ),
            //!_______________________________________
            FlatButton.icon(
              icon: Icon(Icons.add),
              label: Text(''),
              onPressed: () => _showForm('addRecipe'),
            ),
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.settings),
              label: Text('settings'),
              onPressed: () => _showForm('settings'),
            ),
          ],
        ),
         body: _pageOptions[_selectedPage],
        //Column(
        //   children: <Widget>[
        //     Expanded(
        //       child: Container(
        //         //! ________________________________________________________________
        //         //TODO: Find a decent image to use as our background...
        //         decoration: BoxDecoration(
        //           image: DecorationImage(
        //             colorFilter: ColorFilter.mode(
        //                 Colors.black.withOpacity(0.3), BlendMode.dstOut),
        //             image: AssetImage('assets/img/pantry_chef_green.png'),
        //             fit: BoxFit.cover,
        //           ),
        //         ),
        //         //! ________________________________________________________________
        //         // child: UserList()
        //         child: RecipeList(),
        //       ),
        //     ),
        //   ],
        // ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, //enables background colour for nav bar
          backgroundColor: Colors.green[100],
          currentIndex: _selectedPage,
          onTap: (index) {
            setState(() {
              _selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: Text('Home'),
              
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.wb_sunny), //use a better icon, perhaps one we make.
              title: Text('Pantry'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.delete),
              title: Text('Waste'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.calendar_today),
              title: Text('Schedule'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.feedback),
              title: Text('Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
