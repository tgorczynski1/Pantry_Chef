import 'package:flutter/material.dart';
import 'package:pantry_chef/models/user.dart';
import 'package:pantry_chef/style/styles.dart';
import 'package:provider/provider.dart';

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  String title;
  var issueDropDown = [
    'App doesn\'t work as intended ',
    'My information didn\'t save',
    'The user interface breaks for me',
    'I have a suggestion',
    'Other',
  ];
  String issueDropDownSelection;
  String messge;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Form(
      key: _formKey,
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              'Send Feedback',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36.0,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Title'),
            TextFormField(
                decoration: kTextFieldDecoration,
                onChanged: (val) => setState(() {
                      title = val;
                    })),
            SizedBox(
              height: 10,
            ),
            DropdownButton(
              value: issueDropDownSelection,
              hint: Text('Issue'),
              elevation: 3,
              items: issueDropDown.map((val) {
                return new DropdownMenuItem(value: val, child: new Text(val));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  issueDropDownSelection = val;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text('Message'),
            TextFormField(
              decoration: kTextFieldDecoration,
              minLines: 4,
              maxLines: 10,
            ),
            RoundedButton(
              onPressed: null,
              color: Colors.grey,
              title: 'Submit',
            ),
          ],
        ),
      ),
    );
  }
}
