import 'package:businesstrack/features/auth/presentation/pages/login_screen.dart';
import 'package:businesstrack/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:businesstrack/features/auth/presentation/state/auth.state.dart';
import 'package:businesstrack/features/auth/presentation/widgets/text_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Listen to Auth Changes (Safe - Not inside build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listen<AuthState>(authViewModelProvider, (previous, next) {
        if (next.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.errorMessage ?? 'Registration failed')),
          );
        } else if (next.status == AuthStatus.registered) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful')),
          );

          // Navigate to LoginScreen (no prefilled data)
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : const LinearGradient(
                  colors: [
                    Color(0xFFEFF3FF),
                    Color(0xFFFFFFFF),
                    Color(0xFFEAF3FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Theme.of(context).colorScheme.surface
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.grey.shade700
                        : Colors.indigo.withOpacity(0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.4 : 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: double.infinity,
                          height: 60,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        "BusinessTrack",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Create your account",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 28),

                      // Full Name
                      TextLayout(
                        controller: nameController,
                        label: "Full Name",
                        hint: "Ram Shrestha",
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 16),

                      // Phone Number
                      TextLayout(
                        controller: phoneController,
                        label: "Phone Number",
                        hint: "+977",
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextLayout(
                        controller: emailController,
                        label: "Email",
                        hint: "email.com",
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextLayout(
                        controller: passwordController,
                        label: "Password",
                        hint: "••••••••",
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please confirm your password";
                          }
                          if (value != passwordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Signup Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: authState.status == AuthStatus.loading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    ref
                                        .read(authViewModelProvider.notifier)
                                        .register(
                                          fullName: nameController.text.trim(),
                                          email: emailController.text.trim(),
                                          username: nameController.text
                                              .trim()
                                              .split('@')
                                              .first,
                                          password: passwordController.text,
                                          confirmPassword:
                                              confirmPasswordController.text,
                                          phoneNumber: phoneController.text
                                              .trim(),
                                        );
                                  }
                                },
                          child: authState.status == AuthStatus.loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Create Account"),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Already have an account?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              "Login",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
