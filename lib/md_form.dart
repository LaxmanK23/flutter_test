import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

void main() => runApp(MaterialApp(home: MarkdownFormPage()));

class MarkdownFormPage extends StatefulWidget {
  @override
  State<MarkdownFormPage> createState() => _MarkdownFormPageState();
}

class _MarkdownFormPageState extends State<MarkdownFormPage> {
  final Map<String, TextEditingController> controllers = {};
  final String markdownData =
      'Hello [name, {label:Name, isValidate: true,type:textFormField,id:name,value:John Doe }], your email is [email].';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Markdown Inline Inputs')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MarkdownBody(
          data: markdownData,
          inlineSyntaxes: [DynamicInputSyntax()],
          builders: {'customInput': DynamicInputBuilder(controllers)},
        ),
      ),
    );
  }
}

// Step 1: Custom Syntax [field]
class DynamicInputSyntax extends md.InlineSyntax {
  DynamicInputSyntax() : super(r'\[([a-zA-Z0-9_]+),\s*({.*?})\]');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final fieldName = match.group(1)!;
    final jsonRaw = match.group(2)!;
    print('jsonRaw: $jsonRaw');
    final element = md.Element.withTag('customInput');
    element.attributes['name'] = fieldName;
    parser.addNode(element);
    return true;
  }
}

// Step 2: Builder for each <customInput name="fieldName" />
class DynamicInputBuilder extends MarkdownElementBuilder {
  final Map<String, TextEditingController> controllers;

  DynamicInputBuilder(this.controllers);

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final fieldName = element.attributes['name']!;
    controllers.putIfAbsent(fieldName, () => TextEditingController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        width: 120,
        height: 30,
        child: TextField(
          controller: controllers[fieldName],
          decoration: InputDecoration(
            hintText: fieldName,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
