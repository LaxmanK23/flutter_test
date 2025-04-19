import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(OpenLink());
}

class OpenLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OpenLinkScreen(),
    );
  }
}

class OpenLinkScreen extends StatefulWidget {
  @override
  _OpenLinkScreenState createState() => _OpenLinkScreenState();
}

class _OpenLinkScreenState extends State<OpenLinkScreen> {
  @override
  void initState() {
    super.initState();
    _launchURL(); // Automatically open the link when the screen is initialized
  }

  void _launchURL() async {
    const url = 'https://www.example.com';
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open Link Example'),
      ),
      body: Center(
        child: Text('Opening link...'),
      ),
    );
  }
}
