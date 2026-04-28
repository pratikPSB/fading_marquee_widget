import 'package:flutter/material.dart';

/// Flutter widget for displaying fading edge at start/end of scroll views
class FadingEdgeScrollView extends StatefulWidget {
  /// child widget
  final Widget child;

  /// scroll controller of child widget
  ///
  /// Look for more documentation at [ScrollView.scrollController]
  final ScrollController scrollController;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// Look for more documentation at [ScrollView.reverse]
  final bool reverse;

  /// The axis along which child view scrolls
  ///
  /// Look for more documentation at [ScrollView.scrollDirection]
  final Axis scrollDirection;

  /// what part of screen on start half should be covered by fading edge gradient
  /// [gradientFractionOnStart] must be 0 <= [gradientFractionOnStart] <= 1
  /// 0 means no gradient,
  /// 1 means gradients on start half of widget fully covers it
  final double gradientFractionOnStart;

  /// what part of screen on end half should be covered by fading edge gradient
  /// [gradientFractionOnEnd] must be 0 <= [gradientFractionOnEnd] <= 1
  /// 0 means no gradient,
  /// 1 means gradients on start half of widget fully covers it
  final double gradientFractionOnEnd;

  /// Duration for fade effect appear/disappear transition
  final Duration fadeDuration;

  const FadingEdgeScrollView._internal({
    super.key,
    required this.child,
    required this.scrollController,
    required this.reverse,
    required this.scrollDirection,
    required this.gradientFractionOnStart,
    required this.gradientFractionOnEnd,
    required this.fadeDuration,
  }) : assert(gradientFractionOnStart >= 0 && gradientFractionOnStart <= 1),
       assert(gradientFractionOnEnd >= 0 && gradientFractionOnEnd <= 1);

  /// Constructor for creating [FadingEdgeScrollView] with [ScrollView] as child
  /// child must have [ScrollView.controller] set
  factory FadingEdgeScrollView.fromScrollView({
    Key? key,
    required ScrollView child,
    double gradientFractionOnStart = 0.1,
    double gradientFractionOnEnd = 0.1,
    Duration fadeDuration = Duration.zero,
  }) {
    final controller = child.controller;
    if (controller == null) {
      throw Exception("Child must have controller set");
    }

    return FadingEdgeScrollView._internal(
      key: key,
      scrollController: controller,
      scrollDirection: child.scrollDirection,
      reverse: child.reverse,
      gradientFractionOnStart: gradientFractionOnStart,
      gradientFractionOnEnd: gradientFractionOnEnd,
      fadeDuration: fadeDuration,
      child: child,
    );
  }

  /// Constructor for creating [FadingEdgeScrollView] with [SingleChildScrollView] as child
  /// child must have [SingleChildScrollView.controller] set
  factory FadingEdgeScrollView.fromSingleChildScrollView({
    Key? key,
    required SingleChildScrollView child,
    double gradientFractionOnStart = 0.1,
    double gradientFractionOnEnd = 0.1,
    Duration fadeDuration = Duration.zero,
  }) {
    final controller = child.controller;
    if (controller == null) {
      throw Exception("Child must have controller set");
    }

    return FadingEdgeScrollView._internal(
      key: key,
      scrollController: controller,
      scrollDirection: child.scrollDirection,
      reverse: child.reverse,
      gradientFractionOnStart: gradientFractionOnStart,
      gradientFractionOnEnd: gradientFractionOnEnd,
      fadeDuration: fadeDuration,
      child: child,
    );
  }

  /// Constructor for creating [FadingEdgeScrollView] with [PageView] as child
  /// child must have [PageView.controller] set
  factory FadingEdgeScrollView.fromPageView({
    Key? key,
    required PageView child,
    double gradientFractionOnStart = 0.1,
    double gradientFractionOnEnd = 0.1,
    Duration fadeDuration = Duration.zero,
  }) {
    final controller = child.controller;
    //ignore: unnecessary_null_comparison
    if (controller == null) {
      throw Exception("Child must have controller set");
    }

    return FadingEdgeScrollView._internal(
      key: key,
      scrollController: controller,
      scrollDirection: child.scrollDirection,
      reverse: child.reverse,
      gradientFractionOnStart: gradientFractionOnStart,
      gradientFractionOnEnd: gradientFractionOnEnd,
      fadeDuration: fadeDuration,
      child: child,
    );
  }

  /// Constructor for creating [FadingEdgeScrollView] with [AnimatedList] as child
  /// child must have [AnimatedList.controller] set
  factory FadingEdgeScrollView.fromAnimatedList({
    Key? key,
    required AnimatedList child,
    double gradientFractionOnStart = 0.1,
    double gradientFractionOnEnd = 0.1,
    Duration fadeDuration = Duration.zero,
  }) {
    final controller = child.controller;
    if (controller == null) {
      throw Exception("Child must have controller set");
    }

    return FadingEdgeScrollView._internal(
      key: key,
      scrollController: controller,
      scrollDirection: child.scrollDirection,
      reverse: child.reverse,
      gradientFractionOnStart: gradientFractionOnStart,
      gradientFractionOnEnd: gradientFractionOnEnd,
      fadeDuration: fadeDuration,
      child: child,
    );
  }

  /// Constructor for creating [FadingEdgeScrollView] with [ScrollView] as child
  /// child must have [ScrollView.controller] set
  factory FadingEdgeScrollView.fromListWheelScrollView({
    Key? key,
    required ListWheelScrollView child,
    double gradientFractionOnStart = 0.1,
    double gradientFractionOnEnd = 0.1,
    Duration fadeDuration = Duration.zero,
  }) {
    final controller = child.controller;
    if (controller == null) {
      throw Exception("Child must have controller set");
    }

    return FadingEdgeScrollView._internal(
      key: key,
      scrollController: controller,
      scrollDirection: Axis.vertical,
      reverse: false,
      gradientFractionOnStart: gradientFractionOnStart,
      gradientFractionOnEnd: gradientFractionOnEnd,
      fadeDuration: fadeDuration,
      child: child,
    );
  }

  @override
  FadingEdgeScrollViewState createState() => FadingEdgeScrollViewState();
}

class FadingEdgeScrollViewState extends State<FadingEdgeScrollView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late ScrollController _controller;
  _ScrollState _scrollState = _ScrollState.notScrollable;
  _ScrollState _previousScrollState = _ScrollState.notScrollable;
  int lastScrollViewListLength = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = widget.scrollController;
    _controller.addListener(_updateScrollState);

    _fadeController = AnimationController(
      duration: widget.fadeDuration,
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addObserver(this);
  }

  bool get _controllerIsReady =>
      _controller.hasClients && _controller.positions.last.hasContentDimensions;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _controller.removeListener(_updateScrollState);
    _fadeController.dispose();
  }

  @override
  void didUpdateWidget(FadingEdgeScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fadeDuration != widget.fadeDuration) {
      _fadeController.duration = widget.fadeDuration;
    }
    if (oldWidget.scrollController != widget.scrollController) {
      _controller.removeListener(_updateScrollState);
      _controller = widget.scrollController;
      _controller.addListener(_updateScrollState);
      _updateScrollState();
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // Add the shading or remove it when the screen resize (web/desktop) or mobile is rotated
    _updateScrollState();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _fadeAnimation,
    builder: (context, _) => ShaderMask(
      shaderCallback: (bounds) => _createShaderGradient().createShader(
        bounds.shift(Offset(-bounds.left, -bounds.top)),
        textDirection: Directionality.of(context),
      ),
      blendMode: BlendMode.dstIn,
      // Catching ScrollMetricsNotifications from the Scrollable child.
      // This way we get notified if the size of the underlying list changes.
      // We then re-evaluate if Gradient should be shown.
      child: NotificationListener<ScrollMetricsNotification>(
        child: widget.child,
        onNotification: (_) {
          _updateScrollState();
          // Enable notification to still bubble up.
          return false;
        },
      ),
    ),
  );

  Gradient _createShaderGradient() => LinearGradient(
    begin: _gradientStart,
    end: _gradientEnd,
    stops: [
      0,
      widget.gradientFractionOnStart * 0.5,
      1 - widget.gradientFractionOnEnd * 0.5,
      1,
    ],
    colors: _getColors(
      widget.gradientFractionOnStart > 0 && _scrollState.isShowGradientAtStart,
      widget.gradientFractionOnEnd > 0 && _scrollState.isShowGradientAtEnd,
    ),
  );

  AlignmentGeometry get _gradientStart =>
      widget.scrollDirection == Axis.vertical
      ? _verticalStart
      : _horizontalStart;

  AlignmentGeometry get _gradientEnd =>
      widget.scrollDirection == Axis.vertical ? _verticalEnd : _horizontalEnd;

  Alignment get _verticalStart =>
      widget.reverse ? Alignment.bottomCenter : Alignment.topCenter;

  Alignment get _verticalEnd =>
      widget.reverse ? Alignment.topCenter : Alignment.bottomCenter;

  AlignmentDirectional get _horizontalStart => widget.reverse
      ? AlignmentDirectional.centerEnd
      : AlignmentDirectional.centerStart;

  AlignmentDirectional get _horizontalEnd => widget.reverse
      ? AlignmentDirectional.centerStart
      : AlignmentDirectional.centerEnd;

  List<Color> _getColors(bool showGradientAtStart, bool showGradientAtEnd) {
    if (widget.fadeDuration == Duration.zero) {
      return [
        showGradientAtStart ? Colors.transparent : Colors.white,
        Colors.white,
        Colors.white,
        showGradientAtEnd ? Colors.transparent : Colors.white,
      ];
    } else {
      final fadeValue = _fadeAnimation.value;

      final bool wasStart = widget.gradientFractionOnStart > 0 &&
          _previousScrollState.isShowGradientAtStart;
      final double alphaStart = wasStart == showGradientAtStart
          ? (showGradientAtStart ? 0.0 : 1.0)
          : (showGradientAtStart ? 1.0 - fadeValue : fadeValue);

      final bool wasEnd = widget.gradientFractionOnEnd > 0 &&
          _previousScrollState.isShowGradientAtEnd;
      final double alphaEnd = wasEnd == showGradientAtEnd
          ? (showGradientAtEnd ? 0.0 : 1.0)
          : (showGradientAtEnd ? 1.0 - fadeValue : fadeValue);

      return [
        (showGradientAtStart ? Colors.transparent : Colors.white)
            .withValues(alpha: alphaStart),
        Colors.white,
        Colors.white,
        (showGradientAtEnd ? Colors.transparent : Colors.white)
            .withValues(alpha: alphaEnd),
      ];
    }
  }

  void _updateScrollState() {
    if (!_controllerIsReady) {
      return;
    }

    final offset = _controller.positions.last.pixels;
    final minOffset = _controller.positions.last.minScrollExtent;
    final maxOffset = _controller.positions.last.maxScrollExtent;

    final isScrolledToEnd = offset >= maxOffset;
    final isScrolledToStart = offset <= minOffset;

    final scrollState = switch ((isScrolledToStart, isScrolledToEnd)) {
      (true, true) => _ScrollState.notScrollable,
      (true, false) => _ScrollState.scrollableAtStart,
      (false, true) => _ScrollState.scrollableAtEnd,
      (false, false) => _ScrollState.scrollableInTheMiddle,
    };

    if (_scrollState != scrollState) {
      setState(() {
        _previousScrollState = _scrollState;
        _scrollState = scrollState;
      });
      // Trigger fade animation on scroll state change
      _fadeController.forward(from: 0.0);
    }
  }
}

enum _ScrollState {
  notScrollable,
  scrollableAtStart,
  scrollableAtEnd,
  scrollableInTheMiddle;

  bool get isShowGradientAtStart =>
      this == _ScrollState.scrollableAtEnd ||
      this == _ScrollState.scrollableInTheMiddle;

  bool get isShowGradientAtEnd =>
      this == _ScrollState.scrollableAtStart ||
      this == _ScrollState.scrollableInTheMiddle;
}
