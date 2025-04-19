// import 'package:flutter/material.dart';
// import 'package:pdfx/pdfx.dart';
// import 'package:http/http.dart' as http;

// class PdfViewerScreen extends StatefulWidget {
//   PdfViewerScreen({Key? key}) : super(key: key);

//   @override
//   _PdfViewerScreenState createState() => _PdfViewerScreenState();
// }

// class _PdfViewerScreenState extends State<PdfViewerScreen> {
//   late PdfController _pdfController;
//   late int _totalPages = 10;
//   late int _currentPage;
//   String pdfUrl = "https://pdfobject.com/pdf/sample.pdf";

//   @override
//   void initState() {
//     super.initState();
//     _currentPage = 0;
//     _pdfController = PdfController(
//       document: PdfDocument.openAsset(pdfUrl), // Change to asset or network URL
//     );

//     // ..addListener(() {
//     //     final pages = _pdfController.pagesCount;
//     //     if (pages != _totalPages) {
//     //       setState(() {
//     //         _totalPages = pages;
//     //       });
//     //     }
//     //   });
//   }

//   @override
//   void dispose() {
//     _pdfController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () async {
//               final response = await http.get(Uri.parse(pdfUrl));

//               final pdf = PdfDocument.openData(response.bodyBytes);
//               _pdfController.loadDocument(pdf);
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: PdfView(
//               controller: _pdfController,
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 onPressed: () {
//                   if (_currentPage > 0) {
//                     setState(() {
//                       _currentPage--;
//                     });
//                     _pdfController.nextPage(_currentPage);
//                   }
//                 },
//               ),
//               Text('Page ${_currentPage + 1} of $_totalPages'),
//               IconButton(
//                 icon: Icon(Icons.arrow_forward),
//                 onPressed: () {
//                   if (_currentPage < _totalPages - 1) {
//                     setState(() {
//                       _currentPage++;
//                     });
//                     // _pdfController.setPage(_currentPage);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
