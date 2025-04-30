import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String markdownData = '''
This is the first line.




This is the second line.


This is the third line.
''';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.pink.shade50,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: MarkdownBody(
            data: markdownData,
            extensionSet: md.ExtensionSet(
              [
                BlankLineBlockSyntax(), // custom block to detect blank lines
                ...md.ExtensionSet.gitHubFlavored.blockSyntaxes,
              ],
              md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
            ),
            builders: {
              'blankline': BlankLineBuilder(),
            },
          ),
        ),
      ),
    );
  }
}

// Custom block syntax to detect and render blank lines
class BlankLineBlockSyntax extends md.BlockSyntax {
  @override
  RegExp get pattern => RegExp(r'^\s*$');

  @override
  bool canParse(md.BlockParser parser) {
    return pattern.hasMatch("${parser.current}");
  }
  @override
  md.Node parse(md.BlockParser parser) {
    parser.advance();
    return md.Element.empty('blankline');
  }
}

// Builder for blank lines
class BlankLineBuilder extends MarkdownElementBuilder {
  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return const SizedBox(height: 20); // vertical gap
  }
}
