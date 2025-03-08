import 'package:flutter/material.dart';
import 'package:habify/viewmodels/login_viewmodel.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final LoginViewmodel _viewmodel = LoginViewmodel();

  @override
  void initState() {
    super.initState();
    _viewmodel.checkLoginStatus(context);
  }

  @override
  void dispose() {
    _viewmodel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image 1 (1).png'),
                fit: BoxFit.cover,
                )
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _viewmodel.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 34),
                      child: Text('Welcome',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                      ),
                      const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        'Habify, your companion for building positive habits!',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    const Text(
                      'Enter Your Name',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _viewmodel.nameController,
                      decoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _viewmodel.emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                     ValueListenableBuilder<String?>(
                      valueListenable: _viewmodel.errorMessage,
                      builder: (context, errorMessage, _) {
                        return errorMessage != null
                            ? Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.red, fontSize: 14),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 40),

                    // Submit Button with Loading State
                    Center(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _viewmodel.isLoading,
                        builder: (context, isLoading, _) {
                          return ElevatedButton(
                            onPressed: isLoading ? null : () => _viewmodel.loginUser(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF29068D),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                ),
                          );
                        },
                      )
                    )

                  ],
                )),),
          )
        ],
      ),
    );
  }
}
