import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OrderAcceptedPage extends StatelessWidget {
  const OrderAcceptedPage({super.key, this.orderId, required this.total});
  final int? orderId;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120, height: 120,
                decoration: const BoxDecoration(
                    color: Color(0xFFEAF7EF), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle, size: 80, color: Color(0xFF53B175)),
              ),
              const SizedBox(height: 24),
              const Text('Your Order has been accepted',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                orderId != null
                    ? 'Order #$orderId • Total \$${total.toStringAsFixed(2)}'
                    : "Your items has been placed and is on it's way to being processed",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: () {

                    context.go('/home');
                  },
                  child: const Text('Track Order'),
                ),
              ),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
