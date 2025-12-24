import 'package:fading_marquee_widget/fading_marquee_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> repeatedStrings = List.filled(30, "Long text vertical.");
  late String result = repeatedStrings.join("\n");

  List<String> repeatedStringsArabic = List.filled(30, "نص طويل عمودي.");
  late String resultArabic = repeatedStringsArabic.join("\n");

  bool isRTL = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                isRTL ? 'عنصر النص المتحرك المتلاشي' : 'Fading Marquee Widget'),
            actions: [
              IconButton(
                icon: Icon(isRTL
                    ? Icons.format_textdirection_l_to_r
                    : Icons.format_textdirection_r_to_l),
                onPressed: () {
                  setState(() {
                    isRTL = !isRTL;
                  });
                },
                tooltip: isRTL ? 'Switch to LTR' : 'Switch to RTL',
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    isRTL ? "مثال على المدة الزمنية" : "Duration example",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Theme.of(context).primaryColor,
                          child: FadingMarqueeWidget(
                            duration: const Duration(seconds: 5),
                            child: Text(
                              isRTL
                                  ? "مدة الرسوم المتحركة هي 5 ثوانٍ. المدة الافتراضية هي 10 ثوانٍ. نص طويل جداً جداً جداً جداً جداً جداً جداً جداً جداً جداً."
                                  : "Duration of the animation is 5 seconds. Default duration is 10 seconds. very very very very very very very very very very long text.",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    isRTL ? "مثال على التوقف المؤقت" : "Pause example",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Theme.of(context).primaryColor,
                          child: FadingMarqueeWidget(
                            disableAnimation: false,
                            pause: const Duration(milliseconds: 0),
                            child: Text(
                              isRTL
                                  ? "لا توقف بين الحلقات مع التأخير الافتراضي. نص طويل جداً جداً جداً جداً جداً."
                                  : "No pause between loop with default delay. very very very very very long text.",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Theme.of(context).primaryColor,
                          child: FadingMarqueeWidget(
                            disableAnimation: false,
                            pause: const Duration(seconds: 5),
                            child: Text(
                              isRTL
                                  ? "توقف 5 ثوانٍ بين الحلقات مع التأخير الافتراضي. نص طويل جداً جداً جداً جداً جداً."
                                  : "5 second pause between loop with default delay. very very very very very long text.",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    isRTL ? "مثال على التأخير" : "Delay example",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Theme.of(context).primaryColor,
                          child: FadingMarqueeWidget(
                            disableAnimation: false,
                            pause: const Duration(milliseconds: 0),
                            delay: const Duration(milliseconds: 0),
                            child: Text(
                              isRTL
                                  ? "لا تأخير ولا توقف بين الحلقات. نص طويل جداً جداً جداً جداً جداً."
                                  : "No delay & pause between loop. very very very very very long text.",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Theme.of(context).primaryColor,
                          child: FadingMarqueeWidget(
                            disableAnimation: false,
                            delay: const Duration(milliseconds: 1000),
                            child: Text(
                              isRTL
                                  ? "تأخير ثانية واحدة مع التوقف الافتراضي بين الحلقات. نص طويل جداً جداً جداً جداً جداً."
                                  : "1 second delay with default pause between loop. very very very very very long text.",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    isRTL ? "مثال على الفجوة" : "Gap example",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Theme.of(context).primaryColor,
                          child: FadingMarqueeWidget(
                            disableAnimation: false,
                            gap: 150,
                            child: Text(
                              isRTL
                                  ? "الفجوة بين نهاية وبداية الجملة هي 150 (الفجوة الافتراضية هي 25). نص طويل جداً جداً جداً جداً جداً جداً جداً جداً جداً جداً."
                                  : "gap between the end & start of the sentence is 150 (default gap is 25). very very very very very very very very very very long text.",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    isRTL
                        ? "مثال على تعطيل الرسوم المتحركة"
                        : "Disable animation example",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Theme.of(context).primaryColor,
                          child: FadingMarqueeWidget(
                            disableAnimation: true,
                            child: Text(
                              isRTL
                                  ? "الرسوم المتحركة متوقفة. نص طويل جداً جداً جداً جداً جداً جداً جداً جداً جداً جداً."
                                  : "Animation stopped. very very very very very very very very very very long text.",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    isRTL
                        ? "مثال على الرسوم المتحركة العمودية"
                        : "Vertical animation example",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 150,
                          padding: const EdgeInsets.all(8.0),
                          color: Theme.of(context).primaryColor,
                          child: FadingMarqueeWidget(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              isRTL ? resultArabic : result,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    isRTL
                        ? "مثال على عنصر مخصص مع RTL"
                        : "Custom widget with RTL example",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Theme.of(context).primaryColor,
                          child: FadingMarqueeWidget(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  isRTL
                                      ? "نص مع أيقونة - يعمل بشكل صحيح مع اتجاه النص من اليمين إلى اليسار"
                                      : "Text with icon - works correctly with right-to-left text direction",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
