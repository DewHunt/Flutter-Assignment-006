import 'dart:math';

import 'package:assignment_006/contact_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _numberTEController = TextEditingController();
  bool _isAddContactInProgress = false;
  final _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  var random = Random();
  final List<ContactList> _contactList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameTEController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  labelText: 'Name',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter contact name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _numberTEController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Number',
                  labelText: 'Number',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter contact number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildAddContactButton(),
              const SizedBox(height: 10),
              const Divider(height: 10),
              _buildContactListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddContactButton() {
    return Visibility(
      visible: _isAddContactInProgress == false,
      replacement: const Center(
        child: CircularProgressIndicator(),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _addContact();
          }
        },
        child: const Text('Add'),
      ),
    );
  }

  Widget _buildContactListView() {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        primary: false,
        itemCount: _contactList.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(height: 1),
        itemBuilder: (context, index) {
          return _buildContactListTile(_contactList[index]);
        },
      ),
    );
  }

  Widget _buildContactListTile(ContactList contactList) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.asset('assets/images/user.png'),
      ),
      title: Text(contactList.name),
      subtitle: Text(contactList.number),
      trailing: const Icon(Icons.call),
      onLongPress: () {
        _showDeleteConfirmationDialoge(contactList.id);
      },
    );
  }

  void _addContact() {
    _isAddContactInProgress = true;
    setState(() {});
    String id =
        List.generate(5, (index) => _chars[random.nextInt(_chars.length)])
            .join();
    String name = _nameTEController.text;
    String number = _numberTEController.text;
    ContactList contactList = ContactList(id: id, name: name, number: number);
    _contactList.add(contactList);
    _isAddContactInProgress = false;
    setState(() {});
  }

  void _showDeleteConfirmationDialoge(String contactId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirmation',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            'Are you sure for delete?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.cancel_presentation,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                _deleteContactInfo(contactId);
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteContactInfo(String contactId) {
    _contactList.removeWhere((contact) => contact.id == contactId);
    setState(() {});
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _numberTEController.dispose();
    super.dispose();
  }
}
