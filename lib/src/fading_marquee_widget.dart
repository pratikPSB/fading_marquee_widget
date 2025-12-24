import 'dart:async';

import 'package:flutter/material.dart';

import 'fading_edge_scroll_view.dart';

class FadingMarqueeWidget extends StatefulWidget {
  /// widget which is wanted to scroll automatically
  final Widget child;

  /// Duration to wait before starting animation
  final Duration delay;

  /// If animation should be stopped and position reset
  final bool disableAnimation;

  /// Duration of marquee animation
  final Duration duration;

  /// Sized between end of child and beginning of next child instance
  final double gap;

  /// Used to track widget instance and prevent rebuilding unnecessarily if parent rebuilds
  final String? id;

  /// Time to pause animation in between loops
  final Duration pause;

  /// Direction of the scroll either vertical or horizontal
  final Axis scrollDirection;

  const FadingMarqueeWidget({
    super.key,
    required this.child,
    this.disableAnimation = false,
    this.delay = const Duration(seconds: 2),
    this.duration = const Duration(seconds: 10),
    this.gap = 25,
    this.id,
    this.pause = const Duration(seconds: 1),
    this.scrollDirection = Axis.horizontal,
  });

  @override
  State<FadingMarqueeWidget> createState() => _FadingMarqueeWidgetState();
}

class _FadingMarqueeWidgetState extends State<FadingMarqueeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late Animation<Offset> offset;
  late final ScrollController scrollController;

  String id = '';
  ValueNotifier<bool> shouldScroll = ValueNotifier<bool>(false);

  @override
  void initState() {
    id = widget.id ?? DateTime.now().toString();

    animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    scrollController = ScrollController();
    if (!widget.disableAnimation) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        animationHandler();
      });
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAnimationOffset();
  }

  void _updateAnimationOffset() {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    if (widget.scrollDirection == Axis.horizontal) {
      offset = Tween<Offset>(
        begin: Offset.zero,
        end: isRTL ? const Offset(.5, 0) : const Offset(-.5, 0),
      ).animate(animationController);
    } else if (widget.scrollDirection == Axis.vertical) {
      offset = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, -.5),
      ).animate(animationController);
    }
  }

  @override
  void didUpdateWidget(covariant FadingMarqueeWidget oldWidget) {
    id = widget.id ?? DateTime.now().toString();

    if (!shouldScroll.value || oldWidget.id != id) {
      animationController.reset();
      shouldScroll.value = false;
    }

    if (!widget.disableAnimation && oldWidget.id != id) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        animationHandler();
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  Future<void> animationHandler() async {
    if (!mounted) return;

    // Ensure the ScrollController is attached before accessing position/jumping.
    // If it's not attached yet, wait a short time and retry once.
    if (!scrollController.hasClients) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted || !scrollController.hasClients) return;
    }

    if (scrollController.position.maxScrollExtent > 0) {
      shouldScroll.value = true;

      await Future.delayed(widget.delay);

      if (!mounted) return;

      if (scrollController.hasClients) {
        if (!widget.disableAnimation) {
          // tiny non-zero offset to trigger the slide effect
          scrollController.jumpTo(0.000000000000000001);
        } else {
          scrollController.jumpTo(0);
        }
      }

      if (shouldScroll.value && mounted) {
        animationController.forward().then((_) async {
          if (scrollController.hasClients) {
            scrollController.jumpTo(0);
          }
          animationController.reset();
          await Future.delayed(widget.pause);

          if (shouldScroll.value && mounted) {
            animationHandler();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadingEdgeScrollView.fromSingleChildScrollView(
      gradientFractionOnStart: widget.disableAnimation ? 0 : 0.1,
      gradientFractionOnEnd: widget.disableAnimation ? 0 : 0.1,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: widget.scrollDirection,
        child: SlideTransition(
          position: offset,
          child: ValueListenableBuilder<bool>(
            valueListenable: shouldScroll,
            builder: (context, shouldScroll, _) {
              if (widget.scrollDirection == Axis.vertical) {
                return buildVerticalWidget(shouldScroll);
              } else {
                return buildHorizontalWidget(shouldScroll);
              }
            },
          ),
        ),
      ),
    );
  }

  Row buildHorizontalWidget(bool shouldScroll) {
    return Row(
      textDirection: Directionality.of(context),
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            end: shouldScroll ? widget.gap : 0,
          ),
          child: widget.child,
        ),
        if (shouldScroll)
          Padding(
            padding: EdgeInsetsDirectional.only(end: widget.gap),
            child: widget.child,
          ),
      ],
    );
  }

  Column buildVerticalWidget(bool shouldScroll) => Column(
    children: [
      Padding(
        padding: EdgeInsets.only(bottom: shouldScroll ? widget.gap : 0),
        child: widget.child,
      ),
      if (shouldScroll)
        Padding(
          padding: EdgeInsets.only(bottom: widget.gap),
          child: widget.child,
        ),
    ],
  );
}
