import 'package:first_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class OrderAcceptedPage extends StatelessWidget {
  const OrderAcceptedPage({super.key, this.orderId, required this.total});
  final int? orderId;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                height: 220,
                child: Lottie.asset(
                  'assets/confetti.json',
                  repeat: false,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const Text('Your Order has been accepted',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textColor,
                  ),

              ),
              const SizedBox(height: 8),
              Text( "Your items has been placed and is on it's way to being processed",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColor.descColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    context.go('/home');
                  },
                  child: const Text('Track Order',
                    style: TextStyle(
                        color: AppColor.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Back to home',
                  style: TextStyle(
                      color: AppColor.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600
                  ),),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
