import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class TwoDimensionalScrollableDemo extends StatelessWidget {
  TwoDimensionalScrollableDemo({super.key});

  final List<Employee> employees = Employee.getEmployees;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Table view Demo"),
      ),
      body: TableView.builder(
          columnCount: 10,
          rowCount: 1000,
          pinnedRowCount: 1,
          pinnedColumnCount: 1,
          columnBuilder: buildTableSpan,
          rowBuilder: buildTableSpan,
          horizontalDetails: ScrollableDetails.horizontal(
              physics: const BouncingScrollPhysics()),
          cellBuilder: (BuildContext context, TableVicinity vicinity) {
            return TableViewCell(child: addText(vicinity));
          }),
    );
  }

  TableSpan buildTableSpan(int index) {
    TableSpanDecoration decoration = TableSpanDecoration(
        color: index == 0 ? Colors.grey[300] : null,
        border: const TableSpanBorder(
            trailing: BorderSide(color: Colors.black),
            leading: BorderSide(color: Colors.black)));
    return TableSpan(
      extent: const FixedTableSpanExtent(50),
      backgroundDecoration: decoration,
    );
  }

  Widget addText(TableVicinity vicinity) {
    if (vicinity.yIndex == 0 && vicinity.xIndex == 0) {
      return const Text("Index");
    } else if (vicinity.yIndex == 0 && vicinity.xIndex == 1) {
      return const Text("name");
    } else if (vicinity.xIndex == 0) {
      return Text(employees[vicinity.yIndex - 1].id);
    } else if (vicinity.xIndex == 1) {
      return Text(employees[vicinity.yIndex - 1].name);
    }
    return Text("");
  }
}

class Employee {
  final String id;
  final String name;
  final String role;
  final String email;
  Employee(
      {required this.id,
      required this.name,
      required this.role,
      required this.email});
  static get getEmployees {
    return [
      Employee(
          id: '1',
          name: 'John Doe',
          role: 'Manager',
          email: 'john@example.com'),
      Employee(
          id: '2',
          name: 'Jane Smith',
          role: 'Developer',
          email: 'jane@example.com'),
      Employee(
          id: '3',
          name: 'Mike Johnson',
          role: 'Designer',
          email: 'mike@example.com'),
      Employee(
          id: '4',
          name: 'Emily Brown',
          role: 'HR Specialist',
          email: 'emily@example.com'),
      Employee(
          id: '5',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '6',
          name: 'John Doe',
          role: 'Manager',
          email: 'john@example.com'),
      Employee(
          id: '7',
          name: 'Jane Smith',
          role: 'Developer',
          email: 'jane@example.com'),
      Employee(
          id: '8',
          name: 'Mike Johnson',
          role: 'Designer',
          email: 'mike@example.com'),
      Employee(
          id: '9',
          name: 'Emily Brown',
          role: 'HR Specialist',
          email: 'emily@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
      Employee(
          id: '10',
          name: 'Alex Lee',
          role: 'Marketing Analyst',
          email: 'alex@example.com'),
    ];
  }
}
