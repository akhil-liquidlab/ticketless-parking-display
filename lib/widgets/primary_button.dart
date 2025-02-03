import 'package:flutter/material.dart';
import 'package:ticketless_parking_display/configs/app_colors.dart';
import 'package:ticketless_parking_display/widgets/custom_text.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: !isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white),
                    SizedBox(width: 8),
                  ],
                  CustomText(
                    text: text,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              )
            : CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }
}
