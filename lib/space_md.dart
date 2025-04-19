import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

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

// Custom block syntax that preserves exact whitespace between paragraphs
class PreserveWhitespaceSyntax extends md.BlockSyntax {
  static final _startPattern = RegExp(r'^');

  @override
  RegExp get pattern => _startPattern;

  const PreserveWhitespaceSyntax();

  @override
  bool canParse(md.BlockParser parser) {
    // We want to process the entire document
    return true;
  }

  @override
  md.Node parse(md.BlockParser parser) {
    // Get the current line and move to the next one
    final currentLine = parser.current.content;
    final container = md.Element('preserve-whitespace', [md.Text(currentLine)]);
    parser.advance();

    // Keep track of consecutive empty lines
    int emptyLineCount = 0;

    // Process remaining lines in the document
    while (!parser.isDone) {
      final line = parser.current.content;

      if (line.trim().isEmpty) {
        // Empty line encountered
        emptyLineCount++;
      } else {
        // Non-empty line encountered

        // If we had empty lines before this, add a special marker
        if (emptyLineCount > 0) {
          final spacer = md.Element('line-spacer', []);
          spacer.attributes['count'] = emptyLineCount.toString();
          container.children!.add(spacer);
          emptyLineCount = 0;
        }

        // Add the current non-empty line
        container.children!.add(md.Text(line));
      }

      parser.advance();
    }

    // If the document ends with empty lines, add a spacer for those too
    if (emptyLineCount > 0) {
      final spacer = md.Element('line-spacer', []);
      spacer.attributes['count'] = emptyLineCount.toString();
      container.children!.add(spacer);
    }

    return container;
  }
}

// Custom builder for the preserve-whitespace container
class PreserveWhitespaceBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    List<Widget> children = [];

    for (var child in element.children!) {
      if (child is md.Element && child.tag == 'line-spacer') {
        // Add a sized box for empty lines
        int count = int.parse(child.attributes['count'] ?? '1');
        children.add(SizedBox(height: count * 24.0));
      } else if (child is md.Text) {
        // Add a text widget for non-empty lines
        if (child.text.isNotEmpty) {
          children.add(Text(
            child.text,
            style: preferredStyle,
          ));
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

// Custom markdown processor that preserves whitespace
class CustomMarkdownProcessor {
  static String processMarkdown(String input) {
    // Split the input by lines
    final lines = input.split('\n');

    // Process each line for Markdown formatting
    List<String> processedLines = [];
    bool inList = false;

    for (var line in lines) {
      // Special handling for headers
      if (line.startsWith('# ')) {
        processedLines.add('<h1>${line.substring(2)}</h1>');
      } else if (line.startsWith('## ')) {
        processedLines.add('<h2>${line.substring(3)}</h2>');
      } else if (line.startsWith('### ')) {
        processedLines.add('<h3>${line.substring(4)}</h3>');
      }
      // Special handling for bullet lists
      else if (line.trim().startsWith('* ')) {
        if (!inList) {
          processedLines.add('<ul>');
          inList = true;
        }
        processedLines.add('<li>${line.trim().substring(2)}</li>');
      }
      // Special handling for numbered lists
      else if (RegExp(r'^\d+\.\s').hasMatch(line.trim())) {
        if (!inList) {
          processedLines.add('<ol>');
          inList = true;
        }
        final content = line.trim().replaceFirst(RegExp(r'^\d+\.\s'), '');
        processedLines.add('<li>$content</li>');
      }
      // Empty line that might close a list
      else if (line.trim().isEmpty && inList) {
        if (inList) {
          inList = false;
          // Check next non-empty line to see if it's still a list
          bool nextLineIsList = false;
          for (int i = lines.indexOf(line) + 1; i < lines.length; i++) {
            if (lines[i].trim().isEmpty) continue;
            nextLineIsList = lines[i].trim().startsWith('* ') ||
                RegExp(r'^\d+\.\s').hasMatch(lines[i].trim());
            break;
          }

          if (!nextLineIsList) {
            processedLines.add('</ul>');
            inList = false;
          } else {
            // Just add an empty line within the list
            processedLines.add('');
          }
        } else {
          processedLines.add('');
        }
      }
      // Regular text
      else {
        if (inList &&
            !line.trim().startsWith('* ') &&
            !RegExp(r'^\d+\.\s').hasMatch(line.trim())) {
          processedLines.add('</ul>');
          inList = false;
        }
        processedLines.add(line);
      }
    }

    // Close any open lists
    if (inList) {
      processedLines.add('</ul>');
    }

    return processedLines.join('\n');
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



This is the second paragraph with a single line break above it.


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
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
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
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: SingleChildScrollView(
                child: Html(
                  data: CustomMarkdownProcessor.processMarkdown(_markdownText),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple HTML renderer widget
class Html extends StatelessWidget {
  final String data;

  const Html({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    List<String> lines = data.split('\n');

    TextStyle defaultStyle = Theme.of(context).textTheme.bodyMedium!;
    TextStyle h1Style = Theme.of(context).textTheme.headlineMedium!;
    TextStyle h2Style = Theme.of(context).textTheme.headlineSmall!;
    TextStyle h3Style = Theme.of(context).textTheme.titleLarge!;

    bool inList = false;
    List<Widget> listItems = [];
    bool isOrderedList = false;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];

      // Count consecutive empty lines
      int emptyLineCount = 0;
      if (line.trim().isEmpty) {
        emptyLineCount = 1;
        int j = i + 1;
        while (j < lines.length && lines[j].trim().isEmpty) {
          emptyLineCount++;
          j++;
        }

        if (emptyLineCount > 0) {
          // Add spacing based on empty line count
          widgets.add(SizedBox(height: emptyLineCount * 20.0));

          // Skip ahead
          i += emptyLineCount - 1;
          continue;
        }
      }

      // Handle HTML tags
      if (line.startsWith('<h1>') && line.endsWith('</h1>')) {
        String content = line.substring(4, line.length - 5);
        widgets.add(Text(content, style: h1Style));
      } else if (line.startsWith('<h2>') && line.endsWith('</h2>')) {
        String content = line.substring(4, line.length - 5);
        widgets.add(Text(content, style: h2Style));
      } else if (line.startsWith('<h3>') && line.endsWith('</h3>')) {
        String content = line.substring(4, line.length - 5);
        widgets.add(Text(content, style: h3Style));
      } else if (line == '<ul>') {
        inList = true;
        isOrderedList = false;
        listItems = [];
      } else if (line == '<ol>') {
        inList = true;
        isOrderedList = true;
        listItems = [];
      } else if (line.startsWith('<li>') && line.endsWith('</li>')) {
        String content = line.substring(4, line.length - 5);
        listItems.add(Text('• $content', style: defaultStyle));
      } else if (line == '</ul>' || line == '</ol>') {
        widgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: listItems,
          ),
        );
        inList = false;
      } else if (line.trim().isNotEmpty) {
        // Regular text
        widgets.add(Text(line, style: defaultStyle));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
