import 'package:flutter_test/flutter_test.dart';
import 'package:hireops/main.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('app boots inside a ProviderScope', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HireOpsApp(),
      ),
    );
    await tester.pump();

    expect(find.byType(HireOpsApp), findsOneWidget);
  });
}
