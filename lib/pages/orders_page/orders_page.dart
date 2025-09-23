import 'package:first_app/api/server_api.dart';
import 'package:first_app/models/api_order.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<ApiOrder>> future;
  final api = ServerApi();

  @override
  void initState() {
    super.initState();
    future = api.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text('My Orders',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
      ),
      body: FutureBuilder<List<ApiOrder>>(
        future: future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final orders = snap.data ?? const <ApiOrder>[];
          if (orders.isEmpty) {
            return const Center(child: Text('You don’t have orders yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            itemCount: orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final o = orders[i];
              final subtitle = [
                if (o.status != null && o.status!.isNotEmpty) o.status!,
                if (o.createdAt != null)
                  '${o.createdAt!.year}-${o.createdAt!.month.toString().padLeft(2, '0')}-${o.createdAt!.day.toString().padLeft(2, '0')}',
                'Items: ${o.itemsCount}',
              ].join(' • ');

              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                  childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  title: Text('Order #${o.id}',
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(subtitle,
                      style: const TextStyle(color: Color(0xFF7C7C7C))),
                  trailing: Text('\$${o.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  children: [
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 74,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: o.items.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 10),
                        itemBuilder: (_, j) {
                          final it = o.items[j];
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: it.imageUrl.isNotEmpty
                                    ? Image.network(it.imageUrl,
                                    width: 64, height: 64, fit: BoxFit.contain)
                                    : Container(
                                  width: 64,
                                  height: 64,
                                  color: const Color(0xFFF3F4F6),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: Text(it.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Text('x${it.quantity}  •  \$${it.price}',
                                      style: const TextStyle(
                                          color: Color(0xFF7C7C7C))),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
