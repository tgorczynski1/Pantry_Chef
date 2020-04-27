import 'package:flutter/material.dart';
import 'package:pantry_chef/services/db_recipe_collection.dart';
import 'package:pantry_chef/widgets/ingredient_text.dart';
import 'package:pantry_chef/style/styles.dart';

class ObjectMapTest extends StatefulWidget {
  @override
  _ObjectMapTestState createState() => _ObjectMapTestState();
}

class _ObjectMapTestState extends State<ObjectMapTest> {
  List<Map<String, Object>> ingredients = [
    {'description': 'green beans', 'quantity': 5, 'uom': 'ml'},
    {'description': 'butter', 'quantity': 1, 'uom': 'stick'},
    {'description': 'cheese', 'quantity': 1, 'uom': 'pound'}
  ];

  // static String numb = '3';
  // static String uomString = 'kg';
  // static var stringString = [{'desc': 'something', 'uom':(numb + uomString)},
  // {'desc': 'something', 'uom':((numb + '1')+uomString)}];

  var temp;
  @override
  Widget build(BuildContext context) {
    //* this is the format to add a new Map<String, Object> to the list
    //ingredients.add({'description':'testingAdd', 'quantity':3, 'uom':'more'});

    //* this will print each ingredient object, but has no reference to an index
    // ingredients.forEach((f)=>{
    //   print(f['description'].toString()),
    //   print(f['quantity'].toString()),
    //   print(f['uom'].toString()),
    // },);

    //* this will display each ingredient object on screen
    return Scaffold(
      body: Column(
        children: <Widget>[
          // ListView.builder(
          //   shrinkWrap: true,
          //   itemCount: ingredients.length,
          //   itemBuilder: (context, int index) {
          //     return TextFormField(
          //         initialValue: ingredients[index].values.join(' ').toString(),
          //         onChanged: (val) => setState(
          //               () => {
          //                  print('$index}'),
          //                 //ingredients[index] = val,
          //                 print(
          //                     '${ingredients[index]}'),
          //               },
          //             ));
          //   },
          // ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: ingredients.length,
            itemBuilder: (context, int index) {
              return Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      initialValue:
                          ingredients[index]['description'].toString(),
                      onChanged: (val) => setState(
                        () => {
                          ingredients[index]['description'] = val,
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: ingredients[index]['quantity'].toString(),
                      onChanged: (val) => setState(
                        () => {
                          ingredients[index]['quantity'] = val,
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      initialValue: ingredients[index]['uom'].toString(),
                      onChanged: (val) => setState(
                        () => {
                          ingredients[index]['uom'] = val,
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          Container(
            child: RoundedButton(
              title: 'Push',
              color: Colors.cyan,
              onPressed: () async {
                print(ingredients.toString());
                await RecipeDatabaseService().updateRecipeDataSingle(
                    'HqedT02do0fJlwAFghWu', ingredients, 'Ingredients');
              },
            ),
          ),
        ],
      ),
    );
  }
}

// return Column(
//        children: <Widget>[
//          Column(
//                   children: ingredients
//                       .map((item) => Container(
//                         child: IngredientText(ingredient: item,),
//                       ))
//                       .toList(),
//                 ),
//                 Container(
//                   child: RoundedButton(
//                     title: 'Push',
//                     color: Colors.cyan,
//                     onPressed: () async {
//                           await () {
//                             setState(() {
//                             });
//                               print('asdfsdfsdfsdsd');
//                           };
//                     },
//                   ),
//                 ),
//        ],
//      );
