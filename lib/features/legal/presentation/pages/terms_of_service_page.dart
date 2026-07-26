import 'package:flutter/material.dart';
import 'package:splito_flutter/core/config/app_branding.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service for ${AppBranding.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text(
              'Last Updated: Today',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Acceptance of Terms\n'
              'By accessing and using our app, you accept and agree to be bound by the terms and provision of this agreement.\n\n'
              '2. Provision of Services\n'
              'We are constantly innovating in order to provide the best possible experience for our users. You acknowledge and agree that the form and nature of the services which we provide may change from time to time without prior notice to you.\n\n'
              '3. User Conduct\n'
              'You agree to use the app only for purposes that are permitted by these terms and any applicable law, regulation or generally accepted practices or guidelines in the relevant jurisdictions.\n\n'
              '4. Termination\n'
              'We may terminate or suspend access to our service immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.\n\n'
              '5. Changes to Terms\n'
              'We reserve the right, at our sole discretion, to modify or replace these Terms at any time.',
            ),
          ],
        ),
      ),
    );
  }
}
