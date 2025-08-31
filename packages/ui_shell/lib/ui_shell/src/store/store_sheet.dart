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
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final it = items[i];
                  return Card(
                    child: ListTile(
                      title: Text(it.title),
                      subtitle: Text(it.subtitle),
                      trailing: FilledButton(
                          onPressed: it.onBuy, child: Text(it.priceText)),
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
