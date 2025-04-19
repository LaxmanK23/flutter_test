import 'package:flutter/material.dart';

void main() {
  runApp(DiffViewerApp());
}

class DiffViewerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Diff Viewer',
      home: DiffScreen(),
    );
  }
}

class DiffScreen extends StatelessWidget {
  final List<String> oldList = [
    'void main() {',
    '  print("Hello, World!");',
    '}',
  ];

  final List<String> newList = [
    'void main() {',
  ];

  @override
  Widget build(BuildContext context) {
    final diffs = calculateDiffs(oldList, newList);

    return Scaffold(
      appBar: AppBar(
        title: Text('Diff Viewer'),
      ),
      body: Row(
        children: [
          // Old list (left side)
          Expanded(
            child: buildCodeList(oldList, diffs, isOriginal: true),
          ),
          // New list (right side)
          Expanded(
            child: buildCodeList(newList, diffs, isOriginal: false),
          ),
        ],
      ),
    );
  }

  List<Diff> calculateDiffs(List<String> oldList, List<String> newList) {
    List<Diff> diffs = [];
    int oldIndex = 0;
    int newIndex = 0;

    while (oldIndex < oldList.length && newIndex < newList.length) {
      if (oldList[oldIndex] == newList[newIndex]) {
        diffs.add(Diff(oldList[oldIndex], ChangeType.unchanged));
        oldIndex++;
        newIndex++;
      } else {
        // Check if it's an addition
        if (newIndex + 1 < newList.length &&
            oldList[oldIndex] != newList[newIndex + 1]) {
          diffs.add(Diff(newList[newIndex], ChangeType.added));
          newIndex++;
        } else {
          diffs.add(Diff(oldList[oldIndex], ChangeType.removed));
          oldIndex++;
        }
      }
    }

    // Handle remaining items
    while (oldIndex < oldList.length) {
      diffs.add(Diff(oldList[oldIndex], ChangeType.removed));
      oldIndex++;
    }
    while (newIndex < newList.length) {
      diffs.add(Diff(newList[newIndex], ChangeType.added));
      newIndex++;
    }

    return diffs;
  }

  Widget buildCodeList(List<String> code, List<Diff> diffs,
      {required bool isOriginal}) {
    return ListView.builder(
      itemCount: code.length,
      itemBuilder: (context, index) {
        final line = code[index];
        final diff = diffs.firstWhere(
          (d) => d.line == line && d.isOriginal == isOriginal,
          orElse: () => Diff(line, ChangeType.unchanged),
        );
        return Container(
          color: getBackgroundColor(diff.changeType),
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          child: Text(
            line,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'monospace',
            ),
          ),
        );
      },
    );
  }

  Color getBackgroundColor(ChangeType changeType) {
    switch (changeType) {
      case ChangeType.added:
        return Colors.green[100]!;
      case ChangeType.removed:
        return Colors.red[100]!;
      case ChangeType.unchanged:
      default:
        return Colors.white;
    }
  }
}

class Diff {
  final String line;
  final ChangeType changeType;
  final bool isOriginal;

  Diff(this.line, this.changeType, {this.isOriginal = true});
}

enum ChangeType { added, removed, unchanged }
