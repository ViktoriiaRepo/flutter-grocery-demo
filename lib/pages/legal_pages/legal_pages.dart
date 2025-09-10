import 'package:flutter/material.dart';

class LegalPage extends StatelessWidget {
  final String title;
  final String body;
  const LegalPage({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Text(
          body,
          style: const TextStyle(height: 1.5, fontSize: 16),
        ),
      ),
    );
  }
}

const _lorem = '''
Welcome! These are sample legal terms.

1. Orders: By placing an order you authorize us to charge your selected payment method.
2. Delivery & Returns: Items may be returned within 14 days if unused and in original packaging.
3. Liability: We are not responsible for delays caused by third-party carriers or force majeure.
4. Privacy: We process your data only to fulfill orders and improve the service.

If you have questions, contact support@example.com.
''';

class TermsPage extends LegalPage {
  const TermsPage({super.key})
      : super(title: 'Terms', body: _lorem);
}

class ConditionsPage extends LegalPage {
  const ConditionsPage({super.key})
      : super(title: 'Conditions', body: _lorem);
}
