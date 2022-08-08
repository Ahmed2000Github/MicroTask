import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  const DateField(
      {Key? key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.iconColor,
      this.onPressed})
      : super(key: key);

  final Color? iconColor;
  final String? labelText;
  final String? valueText;
  final TextStyle? valueStyle;
  final VoidCallback? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText!, style: valueStyle),
            Icon(Icons.arrow_drop_down, color: iconColor ?? Colors.black),
          ],
        ),
      ),
    );
  }
}
