class GroceryIngredient {
  const GroceryIngredient(
    this.description,
    this.quantity,
    this.uom,
  );

  final String description;
  final quantity;
  final String uom;

  Map<String, dynamic> toMap() {
    return {
      'Description': description,
      'Quantity': quantity,
      'UoM': uom,
    };
  }

  bool operator ==(other) =>
      other is GroceryIngredient &&
      other.description == description;
  int get hashCode => description.hashCode ^ quantity.hashCode;
}