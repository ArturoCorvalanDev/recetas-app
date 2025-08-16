import 'package:flutter/material.dart';
import 'package:recetas_app/models/flutter_models.dart';
import 'package:recetas_app/pages/page_login.dart';
import 'package:recetas_app/services/services.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirmation = TextEditingController();
  bool _passwordsMatch = true;
  bool _loading = false; // control de carga

  @override
  void initState() {
    super.initState();

    // Escuchar cambios en ambos campos
    _password.addListener(_validarPasswords);
    _passwordConfirmation.addListener(_validarPasswords);
  }

  void _validarPasswords() {
    setState(() {
      _passwordsMatch = _password.text == _passwordConfirmation.text;
    });
  }

  @override
  void dispose() {
    _userName.dispose();
    _name.dispose();
    _bio.dispose();
    _email.dispose();
    _password.dispose();
    _passwordConfirmation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: cuerpoRegister(),
    );
  }

Widget cuerpoRegister() {
  return Stack(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: _userName,
                decoration: const InputDecoration(
                    icon: Icon(Icons.person), label: Text('Usuario')),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _name,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                    icon: Icon(Icons.person), label: Text('Nombre')),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _bio,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                    icon: Icon(Icons.lock), label: Text('Sobre mi')),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                    icon: Icon(Icons.email), label: Text('Email')),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Este campo es obligatorio";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _password,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock), labelText: 'Contraseña'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Este campo es obligatorio";
                  }
                  if (value.length < 8) {
                    return "La contraseña debe tener al menos 8 caracteres";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordConfirmation,
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                    icon: Icon(Icons.lock), labelText: 'Confirmar contraseña'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Este campo es obligatorio";
                  }
                  if (value != _password.text) {
                    return "Las contraseñas no coinciden";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final registerRequest = RegisterRequest(
                      name: _name.text,
                      username: _userName.text,
                      email: _email.text,
                      password: _password.text,
                      passwordConfirmation: _passwordConfirmation.text,
                      bio: _bio.text,
                    );
                    registerUser(registerRequest, context);
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        icon: const Icon(Icons.error),
                        title: const Text('Error'),
                        content:
                            const Text('Por favor, complete todos los campos.'),
                        actions: [
                          TextButton(
                            child: const Text('Aceptar'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Crear cuenta'),
              ),
            ],
          ),
        ),
      ),
      // Loader centrado
      if (_loading)
        Container(
          color: Colors.black54,
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
    ],
  );
}

Future<void> registerUser(RegisterRequest user, context) async {
  setState(() {
    _loading = true;
  });

  final response = await ApiService.register(user);

  setState(() {
    _loading = false;
  });

  if (response.success == true) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check),
        title: const Text('Registro exitoso'),
        content: const Text('El usuario se ha registrado correctamente.'),
        actions: [
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.error),
        title: const Text('Error'),
        content: Text(response.message),
        actions: [
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

}
