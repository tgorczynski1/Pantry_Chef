import 'package:cloud_firestore/cloud_firestore.dart';

class WasteIngredient {
  const WasteIngredient(
    this.description,
    this.quantity,
    this.price,
    this.uom,
    this.reason,
    this.datedeleted
  );

  final String description;
  final price;
  final quantity;
  final String uom;
  final String reason;
  final Timestamp datedeleted;

  Map<String, dynamic> toMap() {
    return {
      'Description': description,
      'Quantity': quantity,
      'Price' : price,
      'UoM': uom,
      'Reason' : reason,
      'DateDeleted' : datedeleted
    };
  }

  bool operator ==(other) =>
      other is WasteIngredient &&
      other.description == description;
  int get hashCode => description.hashCode ^ quantity.hashCode;
}