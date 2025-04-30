import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Markdown Line Break Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MarkdownLineBreakDemo(),
    );
  }
}

// Widget that preserves line breaks exactly as typed
class PreservedLineBreakText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double lineHeight;

  const PreservedLineBreakText({
    Key? key,
    required this.text,
    this.style,
    this.lineHeight = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Split text by line breaks
    final lines = text.split('\n');
    final List<Widget> lineWidgets = [];

    // Track consecutive empty lines
    int emptyLineCount = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.trim().isEmpty) {
        // Count consecutive empty lines
        emptyLineCount++;
      } else {
        // If we had empty lines, add appropriate spacing
        if (emptyLineCount > 0) {
          lineWidgets.add(SizedBox(height: emptyLineCount * lineHeight));
          emptyLineCount = 0;
        }

        // Add the text line
        lineWidgets.add(Text(
          line,
          style: style,
        ));
      }
    }

    // Handle any trailing empty lines
    if (emptyLineCount > 0) {
      lineWidgets.add(SizedBox(height: emptyLineCount * lineHeight));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lineWidgets,
    );
  }
}

// Simple Markdown processor that handles basic elements
class SimpleMarkdownProcessor {
  static List<Widget> processMarkdown(String input, TextStyle defaultStyle) {
    List<Widget> widgets = [];
    List<String> paragraphs = [];
    String currentParagraph = '';
    int emptyLineCount = 0;
    bool inList = false;
    List<String> listItems = [];

    // Split the input by lines
    final lines = input.split('\n');

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].trim();

      // Handle headers
      if (line.startsWith('# ')) {
        if (currentParagraph.isNotEmpty) {
          paragraphs.add(currentParagraph);
          currentParagraph = '';
        }
        widgets.add(Text(
          line.substring(2),
          style: defaultStyle.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ));
        if (emptyLineCount > 0) {
          widgets.add(SizedBox(height: emptyLineCount * 20.0));
          emptyLineCount = 0;
        }
      }
      // Handle bullet lists
      else if (line.startsWith('* ')) {
        if (!inList) {
          if (currentParagraph.isNotEmpty) {
            paragraphs.add(currentParagraph);
            currentParagraph = '';
          }
          inList = true;
          listItems = [];
        }
        listItems.add(line.substring(2));
      }
      // Handle numbered lists
      else if (RegExp(r'^\d+\.\s').hasMatch(line)) {
        if (!inList) {
          if (currentParagraph.isNotEmpty) {
            paragraphs.add(currentParagraph);
            currentParagraph = '';
          }
          inList = true;
          listItems = [];
        }
        listItems.add(line.replaceFirst(RegExp(r'^\d+\.\s'), ''));
      }
      // Handle empty lines
      else if (line.isEmpty) {
        // Process accumulated text if any
        if (currentParagraph.isNotEmpty) {
          paragraphs.add(currentParagraph);
          currentParagraph = '';
        }

        // If in a list, finish it
        if (inList) {
          widgets.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listItems
                .map((item) => Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: defaultStyle),
                          Expanded(child: Text(item, style: defaultStyle)),
                        ],
                      ),
                    ))
                .toList(),
          ));
          inList = false;
          listItems = [];
        }

        emptyLineCount++;
      }
      // Regular text
      else {
        if (inList) {
          // Finish the list if we've moved on to a paragraph
          widgets.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listItems
                .map((item) => Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: defaultStyle),
                          Expanded(child: Text(item, style: defaultStyle)),
                        ],
                      ),
                    ))
                .toList(),
          ));
          inList = false;
          listItems = [];
        }

        if (emptyLineCount > 0) {
          widgets.add(SizedBox(height: emptyLineCount * 20.0));
          emptyLineCount = 0;
        }

        if (currentParagraph.isEmpty) {
          currentParagraph = line;
        } else {
          currentParagraph += ' $line';
        }
      }
    }

    // Handle any remaining paragraph
    if (currentParagraph.isNotEmpty) {
      paragraphs.add(currentParagraph);
    }

    // Handle any remaining list
    if (inList && listItems.isNotEmpty) {
      widgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listItems
            .map((item) => Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ', style: defaultStyle),
                      Expanded(child: Text(item, style: defaultStyle)),
                    ],
                  ),
                ))
            .toList(),
      ));
    }

    // Add paragraphs to widgets
    for (String paragraph in paragraphs) {
      widgets.add(Text(paragraph, style: defaultStyle));
    }

    return widgets;
  }
}

class MarkdownLineBreakDemo extends StatefulWidget {
  const MarkdownLineBreakDemo({Key? key}) : super(key: key);

  @override
  State<MarkdownLineBreakDemo> createState() => _MarkdownLineBreakDemoState();
}

class _MarkdownLineBreakDemoState extends State<MarkdownLineBreakDemo> {
  late TextEditingController _controller;
  String _markdownText = '';

  @override
  void initState() {
    super.initState();
    // Sample markdown text with multiple line breaks
    _controller = TextEditingController(
      text: '''# Markdown Line Break Demo
This is the first paragraph.



This is the second paragraph with three line breaks above it.


This paragraph has two line breaks above it.



This paragraph has three line breaks above it.




This paragraph has four line breaks above it.

* List item 1
* List item 2

1. Numbered item 1
2. Numbered item 2


Text after two line breaks from the list.''',
    );
    _markdownText = _controller.text;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markdown Line Break Demo'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter markdown text here...',
                ),
                onChanged: (value) {
                  setState(() {
                    _markdownText = value;
                  });
                },
              ),
            ),
          ),
          const Divider(height: 2, thickness: 2),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: SingleChildScrollView(
                child: CustomMarkdownRenderer(
                  markdownText: _markdownText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom markdown renderer that preserves line breaks
class CustomMarkdownRenderer extends StatelessWidget {
  final String markdownText;

  const CustomMarkdownRenderer({
    Key? key,
    required this.markdownText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lines = markdownText.split('\n');
    final widgets = <Widget>[];
    int emptyLineCount = 0;
    String currentText = '';
    bool isHeader = false;
    TextStyle style = Theme.of(context).textTheme.bodyMedium!;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Handle headers
      if (line.trim().startsWith('# ')) {
        // Add any accumulated text
        if (currentText.isNotEmpty) {
          widgets.add(Text(currentText, style: style));
          currentText = '';
        }

        // Add spacing if needed
        if (emptyLineCount > 0) {
          widgets.add(SizedBox(height: emptyLineCount * 20.0));
          emptyLineCount = 0;
        }

        // Add header
        widgets.add(Text(
          line.trim().substring(2),
          style: Theme.of(context).textTheme.headlineMedium,
        ));
      }
      // Handle bullet lists
      else if (line.trim().startsWith('* ')) {
        // Add any accumulated text
        if (currentText.isNotEmpty) {
          widgets.add(Text(currentText, style: style));
          currentText = '';
        }

        // Add spacing if needed
        if (emptyLineCount > 0) {
          widgets.add(SizedBox(height: emptyLineCount * 20.0));
          emptyLineCount = 0;
        }

        // Add list item
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ', style: style),
              Expanded(child: Text(line.trim().substring(2), style: style)),
            ],
          ),
        ));
      }
      // Handle numbered lists
      else if (RegExp(r'^\d+\.\s').hasMatch(line.trim())) {
        // Add any accumulated text
        if (currentText.isNotEmpty) {
          widgets.add(Text(currentText, style: style));
          currentText = '';
        }

        // Add spacing if needed
        if (emptyLineCount > 0) {
          widgets.add(SizedBox(height: emptyLineCount * 20.0));
          emptyLineCount = 0;
        }

        // Extract number and content
        final match = RegExp(r'^(\d+)\.\s(.+)$').firstMatch(line.trim());
        final number = match?.group(1) ?? '1';
        final content = match?.group(2) ?? line.trim();

        // Add list item
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$number. ', style: style),
              Expanded(child: Text(content, style: style)),
            ],
          ),
        ));
      }
      // Handle empty lines
      else if (line.trim().isEmpty) {
        // Add any accumulated text
        if (currentText.isNotEmpty) {
          widgets.add(Text(currentText, style: style));
          currentText = '';
        }

        emptyLineCount++;
      }
      // Handle regular text
      else {
        // Add spacing if needed
        if (emptyLineCount > 0) {
          widgets.add(SizedBox(height: emptyLineCount * 20.0));
          emptyLineCount = 0;
        }

        // Start new paragraph
        if (currentText.isEmpty) {
          currentText = line;
        } else {
          // Continue existing paragraph
          currentText += '\n$line';
        }
      }
    }

    // Add any remaining text
    if (currentText.isNotEmpty) {
      widgets.add(Text(currentText, style: style));
    }

    // Add final spacing if any
    if (emptyLineCount > 0) {
      widgets.add(SizedBox(height: emptyLineCount * 20.0));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
