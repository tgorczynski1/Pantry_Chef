import 'package:flutter/material.dart';
import '../../../utils/picture_scanner.dart';


class OCRTest extends StatelessWidget {

   static final List<String> _exampleWidgetNames = <String>[
    'PictureScanner',
    'CameraPreviewScanner',
    'MaterialBarcodeScanner',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example List'),
      ),
      body: ListView.builder(
        itemCount: _exampleWidgetNames.length,
        itemBuilder: (BuildContext context, int index) {
          final String widgetName = _exampleWidgetNames[index];

          return Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: ListTile(
              title: Text(widgetName),
              onTap: (){ Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PictureScanner(),
                  ),
                );},
            ),
          );
        },
      ),
    );
  }
}