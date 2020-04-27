import 'package:flutter/material.dart';
import 'package:pantry_chef/models/metrics.dart';


class UserTile extends StatelessWidget {
  final Metrics metric;
  UserTile({this.metric});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.pink,
            ),
            title: Text(metric.email),
            subtitle: Text('UID: ${metric.id}'),
            trailing: Text(metric.name),
          ),
        ));
  }
}
