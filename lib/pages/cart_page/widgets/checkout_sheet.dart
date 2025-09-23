import 'package:first_app/api/server_api.dart';
import 'package:first_app/pages/cart_page/bloc/cart_bloc.dart';
import 'package:first_app/utils/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CheckoutSheet extends StatefulWidget {
  const CheckoutSheet({super.key});

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final total = context.select<CartBloc, double>((b) => b.state.totalPrice);

    return SafeArea(
      top: false,

        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text('Checkout',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Total Cost',
                        style: TextStyle(fontSize: 14, color: Colors.black54)),
                    const Spacer(),
                    Text('\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height:20),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                    ),
                    children: [
                      const TextSpan(
                          text:
                          'By placing an order you agree to our ',
                      ),
                      TextSpan(
                        text: 'Terms',
                        style: const TextStyle(
                            color: AppColor.linkColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              final router = GoRouter.of(context);
                              Navigator.of(context, rootNavigator: true).pop();
                              router.pushNamed('terms');
                            },
                      ),
                      const TextSpan(text: ' And '),
                      TextSpan(
                        text: 'Conditions',
                        style: const TextStyle(
                            color: AppColor.linkColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            final router = GoRouter.of(context);
                            Navigator.of(context, rootNavigator: true).pop();
                            router.pushNamed('conditions');
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),

                SizedBox(
                  width: double.infinity,
                  height: 67,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.accentColor,
                      foregroundColor: AppColor.white70,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _loading ? null : () async {
                      setState(() => _loading = true);

                      final bloc  = context.read<CartBloc>();
                      final items = bloc.state.products;

                      final api = ServerApi();
                      final res = await api.createOrder(items);

                      if (!mounted) return;
                      setState(() => _loading = false);

                      if (res.isSuccess) {
                        Navigator.pop(context);
                        context.read<CartBloc>().add(CartClear());
                        context.push('/order/accepted', extra: {
                          'orderId': res.orderId,
                          'total':   res.total,
                        });
                      } else {
                        Navigator.pop(context);
                        _showOrderFailed(context, res.message.isEmpty ? 'Something went wrong.' : res.message);
                      }
                    },
                    child: _loading
                        ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Place Order'
                          ,style: TextStyle(
                          fontSize: 18,
                          color: AppColor.white70,
                          fontWeight: FontWeight.w600,
                        ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }
}

void _showOrderFailed(BuildContext context, String message) {
  showDialog(
    context: context,
    useRootNavigator: true,
    builder: (dialogCtx) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 25,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: CloseButton(
                onPressed: () => Navigator.of(dialogCtx).pop(),
              ),
            ),
            const SizedBox(height: 8),
            Image.asset(
              'assets/order_failed.png',
              width: 140,
              height: 140,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.shopping_bag_outlined, size: 220, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            const Text('Oops! Order Failed',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Something went terribly wrong.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                )
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 67,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF53B175),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19)),
                ),
                child: const Text('Please Try Again',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        )
                )),
              ),

            const SizedBox(height: 8),
            TextButton(
                onPressed: () {
                  Navigator.of(dialogCtx).pop();
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
              child: const Text(
                  'Back to home',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)
                  )
              ),

          ],
        ),
      ),
    ),
  );
}
