import 'package:flutter/material.dart';
import '../history_item.dart';

class HistoryPage extends StatelessWidget {
  Future<List<HistoryItem>> _loadHistoryItems() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      HistoryItem(
        startDate: '2024-10-01',
        endDate: '2024-10-05',
        price: 99.99,
        status: 'Completed',
      ),
      HistoryItem(
        startDate: '2024-09-15',
        endDate: '2024-09-20',
        price: 150.00,
        status: 'Pending',
      ),
      HistoryItem(
        startDate: '2024-08-10',
        endDate: '2024-08-12',
        price: 75.50,
        status: 'Cancelled',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HistoryItem>>(
      future: _loadHistoryItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final historyItems = snapshot.data!;
          return ListView.builder(
            itemCount: historyItems.length,
            itemBuilder: (context, index) {
              final item = historyItems[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Start Date: ${item.startDate}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('End Date: ${item.endDate}'),
                      Text('Price: \$${item.price.toStringAsFixed(2)}'),
                      Text('Status: ${item.status}'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
