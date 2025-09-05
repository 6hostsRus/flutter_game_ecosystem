import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:providers/monetization/monetization_provider.dart';

Future<void> bootstrapMonetization(WidgetRef ref) async {
  final gateway = ref.read(monetizationGatewayProvider);
  final skus = await gateway.listSkus();
  // print or bind to UI list
  for (final s in skus) {
    // ignore: avoid_print
    print('[sku] ${s.id} ${s.title} ${s.price.display} ${s.type}');
  }
}
