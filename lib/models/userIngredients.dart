class UserIngredient {
  var ingredients;


  UserIngredient(
      {
      this.ingredients,

      });
bool operator ==(other) =>
      other is UserIngredient &&
      other.ingredients == ingredients;
  int get hashCode => ingredients.hashCode;
}
