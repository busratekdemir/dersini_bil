import 'package:dersini_bil/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CustomButton renders label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(label: 'Giriş Yap', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Giriş Yap'), findsOneWidget);
  });
}
