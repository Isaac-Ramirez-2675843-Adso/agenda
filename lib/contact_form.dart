import 'package:flutter/material.dart';
import 'db_helper.dart';

class ContactForm extends StatefulWidget {
  final Map<String, dynamic>? contact;
  const ContactForm({super.key, this.contact});

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _address, _email, _phone;

  @override
  void initState() {
    super.initState();
    _name = widget.contact?['name'] ?? '';
    _address = widget.contact?['address'] ?? '';
    _email = widget.contact?['email'] ?? '';
    _phone = widget.contact?['phone'] ?? '';
  }

  void _saveContact() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final contact = {
        'name': _name,
        'address': _address,
        'email': _email,
        'phone': _phone,
      };

      if (widget.contact == null) {
        await DBHelper().insertContact(contact);
      } else {
        await DBHelper().updateContact(contact, widget.contact!['id']);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contact == null ? 'Nuevo Contacto' : 'Editar Contacto',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _address,
                decoration: InputDecoration(labelText: 'Dirección'),
                onSaved: (value) => _address = value!,
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                validator:
                    (value) =>
                        value!.isEmpty || !value.contains('@')
                            ? 'Correo inválido'
                            : null,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                initialValue: _phone,
                decoration: InputDecoration(labelText: 'Teléfono'),
                validator:
                    (value) =>
                        value!.isEmpty || value.length < 10
                            ? 'Teléfono inválido'
                            : null,
                onSaved: (value) => _phone = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _saveContact, child: Text('Guardar')),
            ],
          ),
        ),
      ),
    );
  }
}
