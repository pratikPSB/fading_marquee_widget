import 'package:fading_marquee_widget/fading_marquee_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    "marquee widget test",
    (widgetTester) async {
      var widget = const Directionality(
          textDirection: TextDirection.ltr,
          child: FadingMarqueeWidget(child: Text("testing success")));
      await widgetTester.pumpWidget(widget);
      final foundText = find.byWidget(widget);
      expect(foundText, findsOneWidget);
    },
  );
}
