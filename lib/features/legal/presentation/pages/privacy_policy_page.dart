import 'package:flutter/material.dart';
import 'package:splito_flutter/core/config/app_branding.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy for ${AppBranding.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              'Last Updated: Today',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Information We Collect\n'
              'We collect information you provide directly to us, such as when you create or modify your account, or contact customer support.\n\n'
              '2. How We Use Information\n'
              'We use the information we collect to provide, maintain, and improve our services, such as facilitating expense tracking and settlements.\n\n'
              '3. Information Sharing\n'
              'We do not share your personal information with third parties except as necessary to provide our services or as required by law.\n\n'
              '4. Data Security\n'
              'We take reasonable measures to help protect information about you from loss, theft, misuse and unauthorized access, disclosure, alteration and destruction.\n\n'
              '5. Contact Us\n'
              'If you have any questions about this Privacy Policy, please contact us.',
            ),
          ],
        ),
      ),
    );
  }
}
