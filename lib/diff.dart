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
  final String oldString = 'Hello testing';

  final String newString = 'Hello testing 123';

  @override
  Widget build(BuildContext context) {
    final oldLines = oldString.split('\n');
    final newLines = newString.split('\n');
    final diffs = calculateDiffs(oldLines, newLines);

    return Scaffold(
      appBar: AppBar(
        title: Text('Diff Viewer'),
      ),
      body: Row(
        children: [
          // Old string (left side)
          Expanded(
            child: buildCodeList(oldLines, diffs, isOriginal: true),
          ),
          // New string (right side)
          Expanded(
            child: buildCodeList(newLines, diffs, isOriginal: false),
          ),
        ],
      ),
    );
  }

  List<Diff> calculateDiffs(List<String> oldLines, List<String> newLines) {
    List<Diff> diffs = [];
    int oldIndex = 0;
    int newIndex = 0;

    while (oldIndex < oldLines.length || newIndex < newLines.length) {
      if (oldIndex < oldLines.length && newIndex < newLines.length) {
        if (oldLines[oldIndex] == newLines[newIndex]) {
          diffs.add(Diff(oldLines[oldIndex], ChangeType.unchanged));
          oldIndex++;
          newIndex++;
        } else {
          diffs.add(Diff(oldLines[oldIndex], ChangeType.removed));
          diffs.add(Diff(newLines[newIndex], ChangeType.added));
          oldIndex++;
          newIndex++;
        }
      } else if (oldIndex < oldLines.length) {
        diffs.add(Diff(oldLines[oldIndex], ChangeType.removed));
        oldIndex++;
      } else if (newIndex < newLines.length) {
        diffs.add(Diff(newLines[newIndex], ChangeType.added));
        newIndex++;
      }
    }

    return diffs;
  }

  Widget buildCodeList(List<String> lines, List<Diff> diffs,
      {required bool isOriginal}) {
    return ListView.builder(
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final line = lines[index];
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
