import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketless_parking_display/configs/app_colors.dart';
import 'package:ticketless_parking_display/providers/config_provider.dart';
import 'package:ticketless_parking_display/widgets/custom_text.dart';
import 'package:ticketless_parking_display/widgets/custom_text_field.dart';
import 'package:ticketless_parking_display/widgets/primary_button.dart';

class ConfigScreen extends StatelessWidget {
  ConfigScreen({super.key});

  final TextEditingController _deviceIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context);
    final size = MediaQuery.of(context).size;

    if (!configProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return Container();
    }

    _deviceIdController.text = configProvider.deviceId;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: CustomText(
          text: "Device Configuration",
          color: AppColors.lightText,
          size: 20,
        ),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            onPressed: () {
              configProvider.logout();
              Navigator.pushReplacementNamed(context, '/home');
            },
            icon: Icon(Icons.logout, color: AppColors.lightText),
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          padding: EdgeInsets.symmetric(
            horizontal: size.width > 800 ? 0 : 24,
            vertical: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildUserInfoCard(configProvider),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: _buildDeviceSettingsCard(
                        context,
                        configProvider,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                _buildSystemInfoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(ConfigProvider configProvider) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.account_circle,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12),
                CustomText(
                  text: "User Information",
                  size: 18,
                  weight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(height: 24),
            InfoRow(
              label: "Username",
              value: configProvider.user?.user.username ?? '-',
            ),
            SizedBox(height: 16),
            InfoRow(
              label: "Role",
              value: configProvider.user?.user.role ?? '-',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceSettingsCard(
    BuildContext context,
    ConfigProvider configProvider,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.devices,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12),
                CustomText(
                  text: "Device Settings",
                  size: 18,
                  weight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(height: 24),
            CustomTextField(
              controller: _deviceIdController,
              labelText: "Device ID",
              prefixIcon: Icons.memory,
            ),
            SizedBox(height: 24),
            PrimaryButton(
              text: "Save Changes",
              icon: Icons.save,
              onPressed: () {
                configProvider.updateDeviceId(_deviceIdController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Settings saved successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12),
                CustomText(
                  text: "System Information",
                  size: 18,
                  weight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(height: 24),
            InfoRow(
              label: "Version",
              value: "1.0.0",
            ),
            SizedBox(height: 16),
            InfoRow(
              label: "Last Updated",
              value: DateTime.now().toString().split('.')[0],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          size: 14,
          color: AppColors.darkText.withOpacity(0.6),
        ),
        SizedBox(height: 4),
        CustomText(
          text: value,
          size: 16,
          weight: FontWeight.w500,
        ),
      ],
    );
  }
}
