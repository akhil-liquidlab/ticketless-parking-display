import 'package:flutter/material.dart';
import 'package:ticketless_parking_display/configs/app_colors.dart';
import 'package:ticketless_parking_display/widgets/custom_text.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool obscureText;
  final IconData? prefixIcon;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.obscureText = false,
    this.isPassword = false,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isPassword ? obscureText : false,
      enabled: enabled,
      style: custonTextStyle(
        size: 16,
        weight: FontWeight.w500,
        color: enabled ? null : AppColors.darkText.withOpacity(0.5),
      ),
      decoration: InputDecoration(
        fillColor: AppColors.grey.withAlpha(200),
        filled: true,
        labelText: labelText,
        labelStyle: custonTextStyle(
          size: 14,
          color: AppColors.darkText.withAlpha(100),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.darkText.withAlpha(100))
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
