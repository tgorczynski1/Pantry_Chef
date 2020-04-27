import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pantry_chef/models/user.dart';
import 'package:pantry_chef/models/userWaste.dart';
import 'package:pantry_chef/pages/home/home.dart';
import 'package:pantry_chef/services/db_user_collection.dart';
import 'package:pantry_chef/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class WasteManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserWaste>(
        stream: UserDatabaseService(uid: user.uid).userWaste,
        builder: (context, snapshot) {
          UserWaste userWaste;
          if (snapshot.hasData) {
            userWaste = snapshot.data;

          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Loading();
          }
          //print(userWaste.ingredients);
          if (userWaste == null) {
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.dstOut),
                    image: AssetImage('assets/img/pantry_chef_green.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              padding: EdgeInsets.all(14.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'My Waste Ingredients',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Nothing to show here yet...'),
                ],
              ),
            );
          } else {
            
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.3), BlendMode.dstOut),
                    image: AssetImage('assets/img/pantry_chef_green.png'),
                    fit: BoxFit.cover,
                  ),
                ),
  
              padding: EdgeInsets.all(14.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'My Waste Ingredients',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36, ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    
                    child: ListView.builder(
                      reverse: true,
                        itemCount: userWaste.ingredients.length,
                        itemBuilder: (context, int index) {
                        var time = userWaste.ingredients[index]['DateDeleted'];
                        var temp = timeago.format(time.toDate());
                        if(userWaste.ingredients[index]['Reason'] == null){
                          userWaste.ingredients[index]['Reason'] = 'Other';
                        }
                     var price =  userWaste.ingredients[index]['Price'];
                     print(price.runtimeType);
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Card(
                                    elevation: 8,
                                    
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.brown[100]),

                                      child: ListTile(
                                        leading: Container(
                                          child: userWaste.ingredients[index]['Reason'] == 'Thrown Out' ? Icon(Icons.delete_forever, size: 40,) 
                                          : userWaste.ingredients[index]['Reason'] == 'Compost' ? Icon(Icons.business_center, size: 40,) 
                                          : userWaste.ingredients[index]['Reason'] == 'Used' ? Icon(Icons.fastfood, size: 40,) 
                                          : Icon(Icons.do_not_disturb_alt, size: 40,) ,
                                          //width: 50,
                                          padding: EdgeInsets.only(right:12),
                                          decoration: BoxDecoration(
                                            border: new Border(
                                              right: new BorderSide(width: 1.0, color: Colors.black45)
                                            )
                                          ),
                                        ),
                                        isThreeLine: true,
                                        title: Text(userWaste.ingredients[index]['Description'] +
                                            ' ' + userWaste.ingredients[index]['Quantity'].toString() +
                                            ' ' + userWaste.ingredients[index]['UoM'],
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                        subtitle: 
                                        Text('Bought at: ' + '\$ ' + userWaste.ingredients[index]['Price'].toString() ?? 0 ) ,
                                        trailing: Text(userWaste.ingredients[index]['Reason'] + '\n' + temp ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  )
                ],
              ),
            );
          }
        });
  }
}
