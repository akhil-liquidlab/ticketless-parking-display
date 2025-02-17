import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketless_parking_display/configs/app_colors.dart';
import 'package:ticketless_parking_display/providers/config_provider.dart';
import 'package:ticketless_parking_display/widgets/custom_text.dart';
import 'package:ticketless_parking_display/widgets/custom_text_field.dart';
import 'package:ticketless_parking_display/widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _handleLogin(BuildContext context) async {
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);

    if (await configProvider.authenticate(
      _usernameController.text,
      _passwordController.text,
    )) {
      Navigator.pushReplacementNamed(context, '/config');
    } else {
      _formKey.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);

    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: AppColors.lightText,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/parko_logo.png",
                width: 120,
              ),
              SizedBox(height: 30),
              CustomText(
                text: "Enter your credentials",
                weight: FontWeight.bold,
                size: 16,
              ),
              if (configProvider.errorMessage != null) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: AppColors.error, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: CustomText(
                          text: configProvider.errorMessage!,
                          color: AppColors.error,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _usernameController,
                      labelText: "Username",
                      prefixIcon: Icons.person_outline,
                      enabled:
                          configProvider.authState != AuthState.authenticating,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Username is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      labelText: "Password",
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      enabled:
                          configProvider.authState != AuthState.authenticating,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    PrimaryButton(
                      text: "Login",
                      icon: Icons.login,
                      isLoading:
                          configProvider.authState == AuthState.authenticating,
                      onPressed:
                          configProvider.authState == AuthState.authenticating
                              ? null
                              : () => _handleLogin(context),
                    ),
                    SizedBox(height: 20),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.lightText,
                      ),
                      icon: Icon(Icons.arrow_back, color: AppColors.lightText),
                      label: Text("Go Back"),
                      onPressed: configProvider.authState ==
                              AuthState.authenticating
                          ? null
                          : () =>
                              Navigator.pushReplacementNamed(context, '/home'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
