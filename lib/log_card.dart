import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_log/log_entry.dart';
import 'package:lab_log/log_detail_screen.dart';

class LogCard extends StatelessWidget {
  final LogEntry log;

  const LogCard({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Use the margin from the CardTheme, but add horizontal space
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: ListTile(
        // Add some padding inside the ListTile
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            Icons.science_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 28,
          ),
        ),
        title: Text(
          log.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(DateFormat.yMMMd().format(log.date)),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey.shade400,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LogDetailScreen(log: log)),
          );
        },
      ),
    );
  }
}
