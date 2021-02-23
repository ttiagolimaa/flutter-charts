part of flutter_charts;

/// Show selected item in Cupertino style (Health app)
class SelectedItemDecoration extends DecorationPainter {
  SelectedItemDecoration(
    this.selectedItem, {
    this.selectedColor = Colors.red,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.white,
    this.textSize = 28.0,
    this.animate = false,
    this.selectedArrayIndex = 0,
  });

  final int selectedItem;
  final Color selectedColor;
  final Color backgroundColor;
  final bool animate;

  final Color textColor;
  final double textSize;
  final int selectedArrayIndex;

  @override
  void initDecoration(ChartState state) {
    super.initDecoration(state);
    assert(state.data.stackSize > selectedArrayIndex,
        'Selected key is not in the list!\nCheck the `selectedKey` you are passing.');
  }

  void _drawText(Canvas canvas, Size size, double width, double totalWidth, ChartState state) {
    final _maxValuePainter = ValueDecoration.makeTextPainter(
      state.data.items[selectedArrayIndex][selectedItem].max.toStringAsFixed(2),
      width,
      TextStyle(
        fontSize: textSize,
        color: textColor,
        fontWeight: FontWeight.w700,
      ),
      hasMaxWidth: false,
    );

    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(
              Offset(
                width / 2 - _maxValuePainter.width / 2,
                size.height - textSize * 1.2,
              ),
              Offset(
                width / 2 + _maxValuePainter.width / 2,
                size.height - textSize * 0.2,
              )),
          const Radius.circular(8.0),
        ).inflate(4),
        Paint()..color = selectedColor);

    _maxValuePainter.paint(
      canvas,
      Offset(
        width / 2 - _maxValuePainter.width / 2,
        size.height - textSize * 1.3,
      ),
    );
  }

  @override
  void draw(Canvas canvas, Size size, ChartState state) {
    final int _listSize = state.data.listSize;

    if (selectedItem == null || _listSize <= selectedItem || selectedItem.isNegative) {
      return;
    }

    final _size = state?.defaultPadding?.deflateSize(size) ?? size;
    final _itemWidth = _size.width / _listSize;

    // Save, and translate the canvas so [0,0] is top left of item at [index] position
    canvas.save();
    canvas.translate(
      (state?.defaultPadding?.left ?? 0.0) + (_itemWidth * selectedItem) + state.defaultMargin.left,
      size.height + state.defaultMargin.top + state.defaultPadding.top,
    );

    _drawItem(canvas, Size(_itemWidth, -size.height), state);
    _drawText(canvas, Size(_itemWidth, -size.height), _itemWidth, size.width, state);

    // Restore canvas
    canvas.restore();
  }

  void _drawItem(Canvas canvas, Size size, ChartState state) {
    final _padding = state?.itemOptions?.padding ?? EdgeInsets.zero;

    final _itemWidth = max(state?.itemOptions?.minBarWidth ?? 0.0,
        min(state?.itemOptions?.maxBarWidth ?? double.infinity, size.width - _padding.horizontal));

    const _size = 2.0;
    final _maxValue = state.data.maxValue - state.data.minValue;
    final scale = size.height / _maxValue;

    final _item = state.data.items[selectedArrayIndex][selectedItem];
    // If item is empty, or it's max value is below chart's minValue then don't draw it.
    // minValue can be below 0, this will just ensure that animation is drawn correctly.
    if (_item.isEmpty || _item.max < state.data.minValue) {
      return;
    }

    if ((_item.min ?? 0.0) != 0.0) {
      canvas.drawRect(
        Rect.fromPoints(
          Offset(
            _padding.left + _itemWidth / 2 - _size / 2,
            0.0,
          ),
          Offset(
            _padding.left + _itemWidth / 2 + _size / 2,
            _item.min * scale,
          ),
        ),
        Paint()..color = selectedColor,
      );
    }

    canvas.drawRect(
      Rect.fromPoints(
        Offset(
          _padding.left + _itemWidth / 2 - _size / 2,
          _item.max * scale,
        ),
        Offset(
          _padding.left + _itemWidth / 2 + _size / 2,
          size.height - textSize * 0.2,
        ),
      ),
      Paint()..color = selectedColor,
    );

    canvas.drawRect(
      Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
      Paint()
        ..color = backgroundColor
        ..blendMode = BlendMode.overlay,
    );
  }

  @override
  EdgeInsets marginNeeded() {
    return EdgeInsets.only(top: textSize * 1.3);
  }

  @override
  DecorationPainter animateTo(DecorationPainter endValue, double t) {
    if (endValue is SelectedItemDecoration) {
      return SelectedItemDecoration(
        animate
            ? lerpDouble(selectedItem?.toDouble(), endValue.selectedItem?.toDouble(), t)?.round()
            : endValue.selectedItem,
        selectedColor: Color.lerp(selectedColor, endValue.selectedColor, t),
        backgroundColor: Color.lerp(backgroundColor, endValue.backgroundColor, t),
        textColor: Color.lerp(textColor, endValue.textColor, t),
        textSize: lerpDouble(textSize, endValue.textSize, t),
        animate: endValue.animate,
        selectedArrayIndex: endValue.selectedArrayIndex,
      );
    }

    return this;
  }
}
