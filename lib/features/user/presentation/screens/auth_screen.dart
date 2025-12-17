
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../user/presentation/providers/user_providers.dart';
import '../../../user/domain/entities/user.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  bool _isSignUp = false;
  bool _isLoading = false;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignUp ? 'Sign Up' : 'Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Title
                Icon(
                  Icons.event,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 20),
                Text(
                  'Rental Inventory Booking',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                if (_isSignUp) ...[
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => 
                        value?.isEmpty == true ? 'Full name is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => 
                        value?.isEmpty == true ? 'Phone number is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Delivery Address *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => 
                        value?.isEmpty == true ? 'Address is required' : null,
                  ),

                  const SizedBox(height: 16),


                  // Terms & Conditions Agreement
                  CheckboxListTile(
                    title: Text(
                      'I agree to the Terms & Conditions *',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: const Text(
                      'Payment & damage/loss policy agreement required',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    value: _agreedToTerms,
                    onChanged: (value) {
                      setState(() => _agreedToTerms = value ?? false);
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_isSignUp && !_agreedToTerms)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'You must agree to the Terms & Conditions',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),
                ],

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => 
                      value?.isEmpty == true ? 'Email is required' : null,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password *',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) => 
                      value?.isEmpty == true ? 'Password is required' : null,
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _isLoading ? null : () => _handleSubmit(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)
                      )
                    : Text(_isSignUp ? 'Sign Up' : 'Sign In'),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(_isSignUp 
                    ? 'Already have an account? Sign In'
                    : 'Need an account? Sign Up'
                  ),
                ),

                const SizedBox(height: 24),

                // Demo/Test Users Section
                Text(
                  'Demo Users (for testing):',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Owner: mike.wilson@demo.com / password123\n' +
                  'Client: john.smith@demo.com / password123',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600]
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _quickLogin('john.smith@demo.com', 'password123'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('Quick Login as Client'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _quickLogin('mike.wilson@demo.com', 'password123'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text('Quick Login as Owner'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _quickLogin(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
      _isSignUp = false;
    });
  }


  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() != true) return;

    // Additional validation for signup terms agreement
    if (_isSignUp && !_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the Terms & Conditions'))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userNotifier = ref.read(userNotifierProvider.notifier);

      if (_isSignUp) {
        await userNotifier.signUp(
          fullName: _fullNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          deliveryAddress: _addressController.text.trim(),
        );
      } else {
        await userNotifier.login(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication successful!'))
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed: ${e.toString()}'))
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

