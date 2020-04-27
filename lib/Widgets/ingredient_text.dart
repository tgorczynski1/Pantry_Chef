import 'package:flutter/material.dart';

class IngredientText extends StatelessWidget {

  final Map<String, Object> ingredient;


  const IngredientText(
      {Key key, this.ingredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
                    child: Row(
                      children: <Widget>[
                        Container(
                          child: new Text(
                                ingredient['quantity'].toString() + ' ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                ),
                              ),
                        ),
                        Container(
                          child: new Text(
                                ingredient['uom'].toString() + ' ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                ),
                              ),
                        ),
                        Container(
                          child: new Text(
                                ingredient['description'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                ),
                              ),
                        ),
                      ],
                    ),
                  );
  }
}