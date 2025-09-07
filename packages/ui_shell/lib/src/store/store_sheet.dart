import 'package:flutter/material.dart';

class StoreItem {
  final String title;
  final String subtitle;
  final String priceText;
  final VoidCallback? onBuy;
  const StoreItem(
      {required this.title,
      required this.subtitle,
      required this.priceText,
      this.onBuy});
}

Future<void> showStoreSheet(BuildContext context,
    {required List<StoreItem> items, String title = 'Store'}) {
  return showModalBottomSheet(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    builder: (ctx) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                key: const Key('store:sheet:title'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                key: const Key('store:sheet:list'),
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final it = items[i];
                  return Card(
                    key: Key('store:item:$i'),
                    child: ListTile(
                      key: Key('store:item:$i:tile'),
                      title: Text(it.title, key: Key('store:item:$i:title')),
                      subtitle:
                          Text(it.subtitle, key: Key('store:item:$i:subtitle')),
                      trailing: FilledButton(
                        key: Key('store:item:$i:buy'),
                        onPressed: it.onBuy,
                        child: Text(it.priceText),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
