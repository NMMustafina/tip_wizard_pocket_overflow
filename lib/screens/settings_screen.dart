import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/settings_service.dart';
import 'permanent_tax_amount_screen.dart';
import 'permanent_tip_amount_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double? tipPercentage;
  double? taxAmount;

  @override
  void initState() {
    super.initState();
    loadTipPercentage();
    loadTaxAmount();
  }

  Future<void> loadTipPercentage() async {
    final savedTip = await SettingsService.getDefaultTipPercentage();
    setState(() {
      tipPercentage = savedTip;
    });
  }

  Future<void> loadTaxAmount() async {
    final savedTax = await SettingsService.getDefaultTaxAmount();
    setState(() {
      taxAmount = savedTax;
    });
  }

  void _launchURL() async {
    final Uri url = Uri.parse('https://pub.dev/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        children: [
          const Text(
            'Account',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingsTile(context, LucideIcons.mail, 'Support'),
          _buildSettingsTile(
              context, LucideIcons.shieldCheck, 'Privacy Policy'),
          _buildSettingsTile(context, LucideIcons.fileText, 'Terms of Use'),
          _buildSettingsTile(context, LucideIcons.upload, 'Share with Friends'),
          const SizedBox(height: 30),
          const Text(
            'For you',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingsTile(
            context,
            LucideIcons.percent,
            'Permanent tip amount',
            trailing:
                tipPercentage != null ? '${tipPercentage!.toInt()}%' : '0 %',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PermanentTipAmountScreen(),
                ),
              );
              loadTipPercentage();
            },
          ),
          _buildSettingsTile(
            context,
            LucideIcons.dollarSign,
            'Permanent tax amount',
            trailing:
                taxAmount != null ? '${taxAmount!.toStringAsFixed(2)}%' : '0 %',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PermanentTaxAmountScreen(),
                ),
              );
              loadTaxAmount();
            },
          ),
          const SizedBox(height: 30),
          const Text(
            'More',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          _buildSettingsTile(context, LucideIcons.trash, 'Clear app cache'),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title,
      {String? trailing, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: trailing != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trailing,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.white),
              ],
            )
          : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
      onTap: onTap ?? _launchURL,
    );
  }
}
