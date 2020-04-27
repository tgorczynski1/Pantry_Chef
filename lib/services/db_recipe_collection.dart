import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/recipe.dart';
import 'package:path/path.dart' as Path;
import 'dart:async';

// RECIPES collection reference
class RecipeDatabaseService {
  final String rid;
  RecipeDatabaseService({this.rid});

  final CollectionReference recipeCollection =
      Firestore.instance.collection('Recipes');

  Stream<DocumentSnapshot> printRecipes() {
    return Firestore.instance.collection('Recipes').document().snapshots();
  }

  // recipe list from snapshot
  List<Recipe> _recipeListFromSnapshot(QuerySnapshot snapshot) {
    // this funtion will assign the document ID to the correct recipe after a new addition
    snapshot.documents.forEach((recipe) => {
          if (recipe.data['RecipeId'] != recipe.documentID)
            {
              updateRecipeID(
                recipe.documentID,
                recipe.documentID,
              )
            }
        });
    // print(snapshot.documents.last.documentID);
    return snapshot.documents.map((doc) {
      //!_______________________________________________________
      //TODO: figure out how to display objects {categoryData}
      // var ingredientData = doc.data['Ingredients'];
      var instructionData = doc.data['Instructions'];
      var ingredientData = doc.data['Ingredients'];
      //? var categoryData = doc.data['Category'];
      //? var labelData = doc.data['Labels'];
      //!_______________________________________________________
      // print(ingredientMap.toString());
      //!_______________________________________________________
      return Recipe(
        recipeId: doc.data['RecipeId'] ?? '',
        authorId: doc.data['AuthorId'] ?? '',
        calories: doc.data['Calories'] ?? 0,
        title: doc.data['Title'] ?? '',
        //? category: categoryData.cast<String>() ?? null,
        description: doc.data['Description'] ?? '',
        durationInMin: doc.data['DurationInMin'] ?? null,
        imageUrl: doc.data['ImageUrl'] ?? null,
        ingredients: ingredientData ?? [''],
        instructions: instructionData.cast<String>() ?? [''],
        isRecipe: doc.data['IsRecipe'] ?? null,
        //? labels: labelData.cast<String>() ?? null,
        likes: doc.data['Likes'] ?? null,
        servingSize: doc.data['ServingSize'] ?? null,
      );
    }).toList();
  }

  // recipeData from snapshot
  // RecipeData _recipeDataFromSnapshot(DocumentSnapshot snapshot) {

  //   return RecipeData(
  //       recipeId: snapshot.data['RecipeId'] ?? '',
  //       authorId: snapshot.data['AuthorId'] ?? '',
  //       calories: snapshot.data['Calories'] ?? '',
  //       title: snapshot.data['Title'] ?? '',
  //       category: snapshot.data['Category'] ?? '',
  //       description: snapshot.data['Description'] ?? '',
  //       durationInMin: snapshot.data['DurationInMin'] ?? '',
  //       imageUrl: snapshot.data['ImageURL'] ?? '',
  //       ingredients: snapshot.data['Ingredients'] ?? '',
  //       instructions: snapshot.data['Instructions'] ?? '',
  //       isRecipe: snapshot.data['IsRecipe'] ?? '',
  //       labels: snapshot.data['Labels'] ?? '',
  //       likes: snapshot.data['Likes'] ?? '',
  //       servingSize: snapshot.data['ServingSize'] ?? '',
  //   );
  // }

//!_____________________________________________________________
//!_____________________________________________________________
  Recipe _ingredientsFromRecipe(DocumentSnapshot snapshot) {
    var ingredientData = snapshot.data['Ingredients'];
    return Recipe(
      ingredients: ingredientData ?? [''],
    );
  }

  Stream<Recipe> get singleIngredient {
    return recipeCollection
        .document(rid)
        .snapshots()
        .map(_ingredientsFromRecipe);
  }
//!_____________________________________________________________
//!_____________________________________________________________

  // get recipe stream
  Stream<List<Recipe>> get recipeInfo {
    try {
      return recipeCollection.snapshots().map(_recipeListFromSnapshot);
    } catch (e) {
      print(e.message);
      return null;
    }
  }

  // get recipe document stream
  // Stream<RecipeData> get recipeData {
  //   return recipeCollection.document(uid).snapshots()
  //   .map(_recipeDataFromSnapshot);
  // }
  Future createRecipeData(
      String authorId,
      int calories,
      String description,
      int durInMin,
      List<Map<String, Object>> ingredients,
      // List<String> ingredients,
      List<String> instructions,
      bool isRecipe,
      int likes,
      int servingSize,
      String title,
      var image) async {
    if (image != '') {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('recipes/${Path.basename(image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.onComplete;

      var temp = await storageReference.getDownloadURL();
      temp.toString();
      print(temp);

      return await recipeCollection.document().setData({
        'AuthorId': authorId,
        'Calories': calories,
        // //? category: categoryData.cast<String>() ?? null,
        'Description': description,
        'DurationInMin': durInMin,
        'ImageUrl': temp,
        'Ingredients': ingredients,
        'Instructions': instructions,
        'IsRecipe': isRecipe,
        // //? labels: labelData.cast<String>() ?? null,
        'Likes': likes,
        'ServingSize': servingSize,
        'Title': title,
      });
    } else {
      return await recipeCollection.document().setData({
        'AuthorId': authorId,
        'Calories': calories,
        // //? category: categoryData.cast<String>() ?? null,
        'Description': description,
        'DurationInMin': durInMin,
        'ImageUrl': 'https://via.placeholder.com/150',
        'Ingredients': ingredients,
        'Instructions': instructions,
        'IsRecipe': isRecipe,
        // //? labels: labelData.cast<String>() ?? null,
        'Likes': likes,
        'ServingSize': servingSize,
        'Title': title,
      });
    }
  }

  Future updateRecipeDataSingle(String doc, var data, var table) async {
    return await recipeCollection.document(doc).updateData({'$table': data});
  }

  Future updateRecipeID(
    String doc,
    String recipeId,
  ) async {
    return await recipeCollection.document(doc).updateData({
      'RecipeId': recipeId,
    });
  }
}
//Image Upload to Cloud Storage
// Future chooseFile() async {
//    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {});
//  }

Future uploadFile(var _image) async {
  StorageReference storageReference = FirebaseStorage.instance
      .ref()
      .child('recipes/${Path.basename(_image.path)}}');
  StorageUploadTask uploadTask = storageReference.putFile(_image);
  await uploadTask.onComplete;
  print('File Uploaded');
  //print(storageReference.getDownloadURL());

  var temp = await storageReference.getDownloadURL();
  temp.toString();
  print(temp);
  return temp;
  // final CollectionReference recipeCollection =
  //     Firestore.instance.collection('Recipes');
  //     recipeCollection.document(doc).updateData({'ImageUrl' : temp});
}

Future<String> uploadPic(var _image) async {
  StorageReference storageReference = FirebaseStorage.instance
      .ref()
      .child('recipes/${Path.basename(_image.path)}}');

  //Upload the file to firebase
  StorageUploadTask uploadTask = storageReference.putFile(_image);
  await uploadTask.onComplete;
  //Waits till the file is uploaded then stores the download url
  var location = await storageReference.getDownloadURL();

  //Uri location = (await uploadTask.future).downloadUrl;
  //returns the download url
  return location;
}
