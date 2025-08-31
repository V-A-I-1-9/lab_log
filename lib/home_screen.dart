import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lab_log/log_card.dart';
import 'package:lab_log/log_entry.dart';
import 'package:lab_log/new_entry_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<LogEntry> _logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final logsData = prefs.getString('lab_logs');

    if (logsData == null) {
      return;
    }

    final List<dynamic> decodedList = jsonDecode(logsData);
    final List<LogEntry> loadedLogs = decodedList
        .map((item) => LogEntry.fromJson(item))
        .toList();

    setState(() {
      _logs = loadedLogs;
    });
  }

  Future<void> _saveLogs() async {
    final List<Map<String, dynamic>> encodedList = _logs
        .map((log) => log.toJson())
        .toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lab_logs', jsonEncode(encodedList));
  }

  void _addLog(LogEntry newLog) {
    setState(() {
      _logs.add(newLog);
    });
    _saveLogs();
  }

  void _deleteLog(LogEntry logToDelete) {
    final logIndex = _logs.indexOf(logToDelete);
    final storedLog = logToDelete;

    setState(() {
      _logs.remove(logToDelete);
    });
    _saveLogs();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Log deleted.'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _logs.insert(logIndex, storedLog);
            });
            _saveLogs();
          },
        ),
      ),
    );
  }

  void _navigateAndAddEntry(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewEntryScreen(onAddLog: _addLog),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LabLog'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _logs.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.science_outlined,
                    size: 80,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Logs Yet',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap the + button to add your first lab log.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return Dismissible(
                  key: ValueKey(log.id),
                  onDismissed: (direction) {
                    _deleteLog(log);
                  },
                  background: Container(
                    color: Colors.red.withOpacity(0.8),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  child: LogCard(log: log),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndAddEntry(context),
        tooltip: 'New Log',
        child: const Icon(Icons.add),
      ),
    );
  }
}
