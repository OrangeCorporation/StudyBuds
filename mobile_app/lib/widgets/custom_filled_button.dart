import 'package:flutter/material.dart';

class CustomFilledButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? iconData;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final double? fontSize;
  final double? rotationAngle;
  final double? width;
  final double? height;
  final bool isEnabled;

  /// Creates a [CustomFilledButton] widget.
  ///
  /// The [label] and [onPressed] parameters must not be null.
  ///
  /// The [iconData] parameter is optional. If provided, the icon will appear next to the label.
  ///
  /// The [foregroundColor] parameter is optional. Defaults to white if not provided.
  ///
  /// The [backgroundColor] parameter is optional. Defaults to the primary color if not provided.
  ///
  /// The [fontSize] parameter is optional. Defaults to 14 if not provided.
  ///
  /// The [width] and [height] parameters are optional for customizing button size.

  const CustomFilledButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.iconData,
    this.foregroundColor = Colors.white,
    this.backgroundColor,
    this.fontSize = 14,
    this.rotationAngle = 0,
    this.width,
    this.height,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonBackgroundColor =
        backgroundColor ?? Theme.of(context).primaryColor;
    final disabledBackgroundColor = Colors.grey.shade400;
    final disabledForegroundColor = Colors.grey.shade600;

    final buttonStyle = ButtonStyle(
      backgroundColor:  isEnabled ? WidgetStateProperty.all(buttonBackgroundColor) : WidgetStateProperty.all(disabledBackgroundColor),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0),
                ),
              ),
      fixedSize: width != null && height != null
          ? WidgetStateProperty.all(Size(width!, height!))
          : null,
    );
    final buttonContent = rotationAngle == 0
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconData != null)
                Icon(
                  iconData,
                  color: isEnabled ? foregroundColor : disabledForegroundColor,
                  size: fontSize != null ? fontSize! + 4 : 18,
                ),
              if (iconData != null) const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isEnabled ? foregroundColor : disabledForegroundColor,
                  fontSize: fontSize,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          )
        : RotatedBox(
            quarterTurns: (rotationAngle! / 1.57).round(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconData != null)
                  Icon(
                    iconData,
                    color: isEnabled ? foregroundColor : disabledForegroundColor,
                    size: fontSize != null ? fontSize! + 4 : 18,
                  ),
                if (iconData != null) const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isEnabled ? foregroundColor : disabledForegroundColor,
                    fontSize: fontSize,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );

    return FilledButton(
      onPressed: isEnabled ? onPressed : null,
      style: buttonStyle,
      child: buttonContent,
    );
  }
}

