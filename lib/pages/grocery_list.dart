import 'package:flutter/material.dart';
import 'package:pantry_chef/models/user.dart';
import 'package:pantry_chef/models/userIngredients.dart';
import 'package:pantry_chef/services/db_user_collection.dart';
import 'package:pantry_chef/shared/loading.dart';
import 'package:provider/provider.dart';

class GroceryList extends StatelessWidget {
  final list;

  // In the constructor, require a List.
  GroceryList({Key key, @required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    var myIngredients = [];
    var _updatedList = [];
    int indexToRemove;

    return StreamBuilder<UserIngredient>(
        stream: UserDatabaseService(uid: user.uid).userIngredient,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserIngredient userIngredient = snapshot.data;

            if(userIngredient.ingredients != null){
            myIngredients = userIngredient.ingredients;
            // print(myIngredients);
            }
            myIngredients.forEach((f){
              if(f['Description'].isNotEmpty){
                for (var i = 0; i < list.length; i++) {
                  if((list[i]['Description'] == f['Description']) && (list[i]['UoM'] == f['UoM'])){
                    if((f['Quantity'] == list[i]['Quantity']) || (f['Quantity'] > list[i]['Quantity'])){
                      list[i]['Quantity'] = list[i]['Quantity'] - f['Quantity'];
                      if((list[i]['Quantity'] == 0) || (list[i]['Quantity'] < 0)){
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
            if(indexToRemove != null){
            _updatedList.removeAt(indexToRemove);
            }
            // print(_updatedList);
           


            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.green,
                title: const Text('Viewing Grocery List'),
              ),
              body: Container(
                padding: EdgeInsets.all(14.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      'Ingredients',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      // flex: ,
                      child: ListView.builder(
                        itemCount: _updatedList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String ingredientName =
                              _updatedList[index]['Description'];
                          final String quantity =
                              _updatedList[index]['Quantity'].toString();
                          final String uom = _updatedList[index]['UoM'];

                          // if(list[index]['Description'] == ''){
                          //   print(index);
                          // }

                          return Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey)),
                            ),
                            child: Row(
                              children: <Widget>[
                                // ingredient name
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(25, 10, 0, 20)),
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      ingredientName,
                                      style: TextStyle(fontSize: 20),
                                    )),
                                // amount of ingredient and unit of measurement
                                Expanded(
                                    child: Text(quantity + ' ' + uom,
                                        style: TextStyle(fontSize: 20))),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else
            return Loading();
        });
  }
}
