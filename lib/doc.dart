// import 'package:flutter/material.dart'; 
// import 'package:webview_flutter/webview_flutter.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Excel Viewer',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ExcelWebView(),
//     );
//   }
// }



// class ExcelWebView extends StatelessWidget {
//   final String excelLink='https://firebasestorage.googleapis.com/v0/b/daryaerp.appspot.com/o/forms%2F3ZF6LS8VDxIP5doPuNrW_ENG%20-%2028%20MOTOR%20OVERHAUL%20-MEGGER%20RECORD.docx?alt=media&token=13718b7e-0a8d-4f00-9394-22b9b730123e';

//   ExcelWebView();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Excel Document'),
//       ),
//       body: WebView(
//         initialUrl: excelLink,
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     );
//   }
// }
