import 'package:flutter/material.dart';
import 'package:recetas_app/models/flutter_models.dart';
import 'package:recetas_app/pages/page_create_user.dart';
import 'package:recetas_app/services/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController user = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _loading = false;
  @override
  void dispose() {
    // 2️⃣ Liberar memoria
    user.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: cuerpo());
  }

  Widget cuerpo() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://i.pinimg.com/474x/70/87/6a/70876acc5405ac49d00e09671659ca76.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [nombre(), campoUsuario(), campoContrasena(), SizedBox(height: 15.0), botonLogin()],
              ),
            ),
          ),
        ),
        // Loader centrado en toda la pantalla
        if (_loading)
          Container(
            color: Colors.black54, // semitransparente para fondo
            child: Center(child: CircularProgressIndicator(color: Colors.white)),
          ),
      ],
    );
  }

  Widget nombre() {
    return Text(
      'Sing In',
      style: TextStyle(color: Colors.white, fontSize: 35.0, fontWeight: FontWeight.bold),
    );
  }

  Widget campoUsuario() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextFormField(
        controller: user,
        decoration: InputDecoration(
          icon: Icon(Icons.person, color: Colors.white),
          label: Text('Usuario'),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Este campo es obligatorio";
          }
          return null;
        },
      ),
    );
  }

  Widget campoContrasena() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextFormField(
        controller: password,
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(Icons.lock, color: Colors.white),
          label: Text('Contraseña'),
          fillColor: Colors.white,
          filled: true,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Este campo es obligatorio";
          }
          return null;
        },
      ),
    );
  }

  Widget botonLogin() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                String user = this.user.text;
                String password = this.password.text;
                login(user, password, context);
              }
            },
            child: Text('Iniciar Sesion', style: TextStyle(color: Colors.white, fontSize: 20.0)),
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
            },
            child: Text('Registrarse', style: TextStyle(color: Colors.white, fontSize: 20.0)),
          ),
        ),
      ],
    );
  }

  Future<void> login(username, password, context) async {
    setState(() {
      _loading = true;
    });

    final loginRequest = LoginRequest(username: username, password: password);
    final response = await ApiService.login(loginRequest);

    setState(() {
      _loading = false;
    });

    if (response.success) {
      ApiService.authToken = response.data!.token;
      Navigator.pushReplacementNamed(context, '/recipes');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login fallido: ${response.message}')));
    }
  }
}
