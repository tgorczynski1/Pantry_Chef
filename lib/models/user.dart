class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String email;
  final String fname;
  final String lname;
  final String id;
  final bool issubscriber;
  final String age;
  final String weight;
  //final Map<String, bool> labels;
  final bool vegan;
  final bool vegetarian;
  final bool lactosefree;
  final bool keto;
  final bool diabetes;
  final List<String> favorites;
  final imageurl;

  // UserData({this.email, this.fname, this.id});

  UserData(
      {this.email,
      this.fname,
      this.lname,
      this.id,
      this.issubscriber,
      this.age,
      this.weight,
      this.vegan,
      this.vegetarian,
      this.lactosefree,
      this.keto,
      this.diabetes,
      this.favorites,
      this.imageurl});
}
