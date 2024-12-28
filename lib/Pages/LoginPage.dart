import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:okto_bloom_florist/Pages/MainPage.dart';
import 'package:okto_bloom_florist/Pages/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Function to call the login API
  Future<void> _login() async {
    const String url = 'https://payapp.web.id/login.php';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        // Login successful, navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        // Show error message from API
        _showErrorDialog(data['message']);
      }
    } else {
      // Handle failure or network error
      _showErrorDialog('Failed to connect to server');
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 99,
                  height: 56,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/logo.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 120),
              const Text(
                'LOGIN',
                style: TextStyle(
                  color: Color(0xFFD00178),
                  fontSize: 40,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      'Username/Email',
                      'Enter your username/email',
                      controller: _emailController,
                    ),
                    _buildInputField(
                      'Password',
                      'Enter your password',
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 20),
                    _buildSubmitButton(context),
                    const SizedBox(height: 20),
                    _buildRegisterLink(context),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _buildForgotPasswordLink(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hintText, {
    bool obscureText = false,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFD00178), fontSize: 15),
          hintStyle: TextStyle(
              color: const Color(0xFFD00178).withOpacity(0.5), fontSize: 15),
          fillColor: const Color(0xFFD00178).withOpacity(0.2),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD00178)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: const Color(0xFFD00178).withOpacity(0.2)),
          ),
          suffixIcon: obscureText
              ? IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: const Color(0xFFD00178),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState?.validate() ?? false) {
          setState(() {
            _isLoading = true;
          });
          _login(); // Call the login function
        }
      },
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: ShapeDecoration(
          color: const Color(0xFFD00178),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Masuk',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Forgot Password"),
              content: const Text(
                  "Password recovery functionality to be implemented."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          );
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            color: Color(0xFFD00178),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
          ),
          children: [
            const TextSpan(text: 'Belum punya akun? '),
            TextSpan(
              text: 'Daftar disini',
              style: const TextStyle(
                color: Color(0xFFD00178),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
