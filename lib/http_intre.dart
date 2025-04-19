// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:http_interceptor/http_interceptor.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('HTTP Interceptor Example')),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: _makeRequest,
//             child: const Text('Make Request'),
//           ),
//         ),
//       ),
//     );
//   }

//   void _makeRequest() async {
//     try {
//       final response = await client
//           .get(Uri.parse('https://jsonplaceholder.typicode.com/posts/1'));
//       print('Response body: ${response.body}');
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
// }

// final http.Client client = InterceptedClient.build(
//   interceptors: [
//     LoggingInterceptor(),
//     ErrorInterceptor(),
//   ],
//   retryPolicy: ExpiredTokenRetryPolicy(),
// );

// class LoggingInterceptor implements InterceptorContract {
//   @override
//   Future<RequestData> interceptRequest({required RequestData data}) async {
//     print("Request: ${data.method} ${data.url}");
//     print("Headers: ${data.headers}");
//     print("Body: ${data.body}");
//     return data;
//   }

//   @override
//   Future<ResponseData> interceptResponse({required ResponseData data}) async {
//     print("Response: ${data.statusCode}");
//     print("Headers: ${data.headers}");
//     print("Body: ${data.body}");
//     return data;
//   }
// }

// class ErrorInterceptor implements InterceptorContract {
//   @override
//   Future<RequestData> interceptRequest({required RequestData data}) async {
//     return data;
//   }

//   @override
//   Future<ResponseData> interceptResponse({required ResponseData data}) async {
//     if (data.statusCode >= 400) {
//       print("Error: ${data.statusCode}");
//     }
//     return data;
//   }
// }

// class ExpiredTokenRetryPolicy extends RetryPolicy {
//   @override
//   Future<bool> shouldAttemptRetryOnException(Exception reason) async {
//     return reason is TimeoutException || reason is SocketException;
//   }

//   @override
//   Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
//     return response.statusCode == 401; // Retry on unauthorized
//   }
// }
