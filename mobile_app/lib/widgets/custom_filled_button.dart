import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? iconData;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final double? fontSize;
  final bool isEnabled;

  /// Creates a [CustomFilledButton] widget.
  ///
  /// The [label] and [onPressed] parameters must not be null.
  ///
  /// The [iconData] parameter is optional, in case you don't want to add an icon
  /// for the button, simply do not provide this parameter.
  ///
  /// The [foregroundColor] parameter is optional, if not provided, white color will be used.
  ///
  /// The [backgroundColor] parameter is optional, if not provided, the primary color will be used.
  ///
  /// The [fontSize] parameter is optional, if not provided, the default font size will be used.
  const CustomFilledButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconData,
    this.foregroundColor = Colors.white,
    this.backgroundColor,
    this.fontSize = 14,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonBackgroundColor =
        backgroundColor ?? Theme.of(context).primaryColor;

    final disabledBackgroundColor = Colors.grey.shade400;
    final disabledForegroundColor = Colors.grey.shade600;

    return iconData != null
        ? FilledButton.icon(
            onPressed: isEnabled ? onPressed : null,
            icon: Icon(
              iconData,
              size: fontSize! + 4,
              color: isEnabled ? foregroundColor : disabledForegroundColor,
            ),
            label: Text(
              label,
              style: TextStyle(
                color: isEnabled ? foregroundColor : disabledForegroundColor,
                fontSize: fontSize,
              ),
            ),
            style: ButtonStyle(
              backgroundColor:  isEnabled ? WidgetStateProperty.all(buttonBackgroundColor) : WidgetStateProperty.all(disabledBackgroundColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
          )
        : FilledButton(
            onPressed: onPressed,
            style: ButtonStyle(
              backgroundColor: isEnabled ? WidgetStateProperty.all(buttonBackgroundColor) : WidgetStateProperty.all(disabledBackgroundColor),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isEnabled ? foregroundColor : disabledForegroundColor,
                fontSize: fontSize,
              ),
            ),
          );
  }
}
