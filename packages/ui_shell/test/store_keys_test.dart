import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_shell/ui_shell.dart';

void main() {
  testWidgets('Store button and sheet expose stable keys', (tester) async {
    int buys = 0;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Center(
          child: StoreButton(
            label: 'Open Store',
            onPressed: () => showStoreSheet(
              tester.element(find.byType(StoreButton)),
              title: 'Demo Store',
              items: [
                StoreItem(
                    title: 'S',
                    subtitle: 'Small',
                    priceText: '\$0.99',
                    onBuy: () => buys++),
                StoreItem(
                    title: 'M',
                    subtitle: 'Medium',
                    priceText: '\$1.99',
                    onBuy: () => buys++),
              ],
            ),
          ),
        ),
      ),
    ));

    expect(find.byKey(const Key('store:button')), findsOneWidget);
    await tester.tap(find.byKey(const Key('store:button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('store:sheet:title')), findsOneWidget);
    expect(find.byKey(const Key('store:sheet:list')), findsOneWidget);
    expect(find.byKey(const Key('store:item:0')), findsOneWidget);
    expect(find.byKey(const Key('store:item:0:title')), findsOneWidget);
    expect(find.byKey(const Key('store:item:0:buy')), findsOneWidget);

    await tester.tap(find.byKey(const Key('store:item:0:buy')));
    await tester.pumpAndSettle();
    expect(buys, 1);
  });
}
