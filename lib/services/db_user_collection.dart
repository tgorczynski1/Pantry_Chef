import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pantry_chef/models/metrics.dart';
import 'package:pantry_chef/models/user.dart';
import 'dart:async';
import 'package:path/path.dart' as Path;
import 'package:pantry_chef/models/userIngredients.dart';
import 'package:pantry_chef/models/userWaste.dart';
import 'package:pantry_chef/models/user_meal.dart';

class UserDatabaseService {
  final String uid;
  UserDatabaseService({this.uid});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // USERS collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('Users');

      Future createUserData(
      String email,
      String fname,
      String lname,
      String id,
      bool issubscribed,
      String age,
      String weight,
      bool vegan,
      bool vegetarian,
      bool lactosefree,
      bool keto,
      bool diabetes,
      List<String> favorites,
      ) async {
        

    return await userCollection.document(uid).setData({
      'Email': email,
      'FirstName': fname,
      'LastName': lname,
      'UserId': id,
      'IsSubscribed': issubscribed,
      'Age': age,
      'Weight': weight,
      'Vegan': vegan,
      'Vegetarian': vegetarian,
      'LactoseFree': lactosefree,
      'Keto': keto,
      'Diabetes': diabetes,
      'Favorites': favorites,
      'ImageUrl' : '',
    });
  }

  Future newUserIngredientList() async {
    List<Map<String, Object>> data = [{'Description':'', 'Price':'', 'Quantity':'', 'UoM':'kg'}];

      return userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('IngredientsOnHand')
        .setData({
          'Ingredients': data
        });
  }
  //!_________________________________________
  Future newUserMealPlanList() async {
    List<Map<String, Object>> data = [
      {'Breakfast':'',
      'Day':'Sunday',
      'Dinner':'',
      'Lunch':''},
      {'Breakfast':'',
      'Day':'Monday',
      'Dinner':'',
      'Lunch':''},
      {'Breakfast':'',
      'Day':'Tuesday',
      'Dinner':'',
      'Lunch':''},
      {'Breakfast':'',
      'Day':'Wednesday',
      'Dinner':'',
      'Lunch':''},
      {'Breakfast':'',
      'Day':'Thursday',
      'Dinner':'',
      'Lunch':''},
      {'Breakfast':'',
      'Day':'Friday',
      'Dinner':'',
      'Lunch':''},
      {'Breakfast':'',
      'Day':'Saturday',
      'Dinner':'',
      'Lunch':''}      
      ];

      return userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('MealPlan')
        .setData({
          'WeekPlan': data
        });
  }
  //!_________________________________________

  Future updateUserData(
      String email,
      String fname,
      String lname,
      String id,
      bool issubscribed,
      String age,
      String weight,
      bool vegan,
      bool vegetarian,
      bool lactosefree,
      bool keto,
      bool diabetes,
      List<String> favorites,
      var image) async {
    if(image is File){
      StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profiles/${Path.basename(image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;

    var temp = await storageReference.getDownloadURL();
    temp.toString();
    print(temp);

    // Future updateUserData(String email, String fname, String lname, String id) async {
    return await userCollection.document(uid).updateData({
      'Email': email,
      'FirstName': fname,
      'LastName': lname,
      'UserId': id,
      'IsSubscribed': issubscribed,
      'Age': age,
      'Weight': weight,
      'Vegan': vegan,
      'Vegetarian': vegetarian,
      'LactoseFree': lactosefree,
      'Keto': keto,
      'Diabetes': diabetes,
      'Favorites': favorites,
      'ImageUrl' : temp,
    });
    }else{
      return await userCollection.document(uid).updateData({
      'Email': email,
      'FirstName': fname,
      'LastName': lname,
      'UserId': id,
      'IsSubscribed': issubscribed,
      'Age': age,
      'Weight': weight,
      'Vegan': vegan,
      'Vegetarian': vegetarian,
      'LactoseFree': lactosefree,
      'Keto': keto,
      'Diabetes': diabetes,
      'Favorites': favorites,
      'ImageUrl' : image ?? 'https://via.placeholder.com/150',
    });
    }
    
  }

  Future updateUserDataSingle(var data, var table) async {
    // Future updateUserData(String email, String fname, String lname, String id) async {
    return await userCollection.document(uid).updateData({'$table': data});
  }

// for all deletes, we need to manually delete subcollections, or they will not be terminated and continue to pile/hog storage.
  Future<void> deleteUserData() async {
    FirebaseUser user = await _auth.currentUser();
    await user.delete();
    await userCollection.document(uid).delete();
  }

  // metrics list from snapshot
  List<Metrics> _metricsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Metrics(
        email: doc.data['Email'] ?? '',
        name: doc.data['FirstName'] ?? '',
        id: doc.data['UserId'] ?? '',
      );
    }).toList();
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    //print(snapshot.data['Favorites']);
    var favoriteData = snapshot.data['Favorites'];

    return UserData(
      id: uid,
      fname: snapshot.data['FirstName'],
      lname: snapshot.data['LastName'],
      email: snapshot.data['Email'],
      issubscriber: snapshot.data['IsSubscribed'],
      age: snapshot.data['Age'],
      weight: snapshot.data['Weight'],
      //labels: snapshot.data['Labels'],
      vegan: snapshot.data['Vegan'],
      vegetarian: snapshot.data['Vegetarian'],
      lactosefree: snapshot.data['LactoseFree'],
      keto: snapshot.data['Keto'],
      diabetes: snapshot.data['Diabetes'],
      // favorites: snapshot.data['Favorites'] ?? [''],
      favorites: favoriteData.cast<String>() ?? [''],
      imageurl: snapshot.data['ImageUrl']
    );
  }

  //user ingredient inventory from a subcollection
  UserIngredient _ingredientsFromUser(DocumentSnapshot snapshot) {
    //var test = userCollection.document(uid).snapshots().toString();
    //var message = userCollection.document(uid).collection('FoodInformation').document('IngredientsOnHand').snapshots();
    //print(snapshot.data['Ingredients']);
    //print(message);
    //print(snapshot.documents);

    var ingredientData = snapshot.data['Ingredients'];
    return UserIngredient(
      ingredients: ingredientData ?? [''],
    );
  }

  UserMealPlan _mealsFromUser(DocumentSnapshot snapshot) {
    var mealData = snapshot.data['WeekPlan'];
    return UserMealPlan(
      weekPlan: mealData ?? '',
    );
  }

  UserWaste _userWasteIngredients (DocumentSnapshot snapshot){
    var wastedata = snapshot.data['Ingredients'];
    return UserWaste(
      ingredients: wastedata ?? '',
    );
  }
  Future addUserIngredient(var data) async {
    var snapshot = await userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('IngredientsOnHand')
        .get();

    if(!snapshot.exists){
      return userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('IngredientsOnHand')
        .setData({
          'Ingredients': data
        });

    }
    else
    {
    return userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('IngredientsOnHand')
        .updateData({"Ingredients": FieldValue.arrayUnion(data)});

    }
  }

  Future deleteUserIngredient(var data) async {
    var val = [];
    val.add(data);
    
    return userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('IngredientsOnHand')
        .updateData({"Ingredients": FieldValue.arrayRemove(val)});
    
  }

  Future createWasteIngredient(var waste) async {
    var snapshot = await userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('IngredientWaste')
        .get();
    // var val = [];
    // val.add(waste);
    //print(snapshot);
    //test if document doesnt exist, if so, create it. if not(does exist), append to it.
    if (!snapshot.exists) {
      return await userCollection
          .document(uid)
          .collection('FoodInformation')
          .document('IngredientWaste')
          .setData({
        'Ingredients': waste,
      });
    }
    else
    {
      return await userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('IngredientWaste')
        .updateData({"Ingredients": FieldValue.arrayUnion(waste)});
    }
  }

  Stream<UserIngredient> get userIngredient {
    //print(userCollection.document(uid).collection('FoodInformation').document('IngredientsOnHand').snapshots().map(_ingredientsFromUser));
    return userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('IngredientsOnHand')
        .snapshots()
        .map(_ingredientsFromUser);
  }

  Stream<UserMealPlan> get userMeals {
    return userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('MealPlan')
        .snapshots()
        .map(_mealsFromUser);
  }

  Stream<UserWaste> get userWaste {
    return userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('IngredientWaste')
        .snapshots()
        .map(_userWasteIngredients);
  }

  // get user metrics stream
  Stream<List<Metrics>> get userMetrics {
    return userCollection.snapshots().map(_metricsListFromSnapshot);
  }

  // get user document stream
  Stream<UserData> get userData {
    //print(userCollection.document(uid).snapshots().map(_userDataFromSnapshot));
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future updateUserIngredients(var ingredients) async {
    return await userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('IngredientsOnHand')
        .setData({
      'Ingredients': ingredients,
    });
  }

  Future updateUserMeal(
    var plan,
  ) async {
    // Future updateUserData(String email, String fname, String lname, String id) async {
    return await userCollection
        .document(uid)
        .collection('FoodInformation')
        .document('MealPlan')
        .setData({
      'WeekPlan': plan,
    });
  }
}
