import 'package:flutter/material.dart';
import 'package:pantry_chef/models/metrics.dart';
import 'package:pantry_chef/widgets/user_list_tile.dart';
import 'package:provider/provider.dart';


class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final metrics = Provider.of<List<Metrics>>(context) ?? [];

    //! This is for testing purposes...
    // metrics.forEach((metric){
    //   print(metric.email);
    //   print(metric.name);
    //   print(metric.id);
    // });

    return ListView.builder(
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        return UserTile(metric: metrics[index]);
      },
    );
  }
}
