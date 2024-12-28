import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:okto_bloom_florist/Pages/LoginPage.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    const String url = 'https://payapp.web.id/register.php';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': _usernameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['value'] == 1) {
        // Registration successful, navigate to LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Failed'),
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
          height: MediaQuery.of(context).size.height, // Full screen height
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the form vertically
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
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
              const SizedBox(height: 40),
              // Title
              const Text(
                'REGISTER',
                style: TextStyle(
                  color: Color(0xFFD00178),
                  fontSize: 40,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField('Nama', 'Enter your name',
                        controller: _nameController),
                    _buildInputField('Email', 'Enter your email',
                        isEmail: true, controller: _emailController),
                    _buildInputField('Username', 'Enter your username',
                        controller: _usernameController),
                    _buildInputField('Password', 'Enter your password',
                        obscureText: true, controller: _passwordController),
                    _buildInputField('Alamat', 'Enter your address',
                        controller: _addressController),
                    _buildInputField('Telepon', 'Enter your phone number',
                        isPhone: true, controller: _phoneController),
                    const SizedBox(height: 20),
                    _buildSubmitButton(context),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              // Login link centered below the register button
              Center(child: _buildLoginLink(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hintText,
      {bool obscureText = false,
      bool isEmail = false,
      bool isPhone = false,
      TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: isEmail
            ? TextInputType.emailAddress
            : (isPhone ? TextInputType.phone : TextInputType.text),
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
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          if (isEmail &&
              !RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                  .hasMatch(value)) {
            return 'Enter a valid email';
          }
          if (isPhone && value.length != 12) {
            return 'Enter a valid phone number';
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
          _register(); // Call the register function
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
                  'Daftar',
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

  Widget _buildLoginLink(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        children: [
          const TextSpan(text: 'Sudah punya akun? '),
          TextSpan(
            text: 'Login disini',
            style: const TextStyle(
              color: Color(0xFFD00178),
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
          ),
        ],
      ),
    );
  }
}
