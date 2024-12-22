import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'contact_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final contacts = await DBHelper().getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  void _navigateToForm({Map<String, dynamic>? contact}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ContactForm(contact: contact)),
    );
    _loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agenda')),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return ListTile(
            title: Text(contact['name']),
            subtitle: Text(contact['phone']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _navigateToForm(contact: contact),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await DBHelper().deleteContact(contact['id']);
                    _loadContacts();
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToForm(),
      ),
    );
  }
}
