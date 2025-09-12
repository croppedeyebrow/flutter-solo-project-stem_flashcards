import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'app_colors.dart';

class GlassmorphismWidget extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassmorphismWidget({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 16.0,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderColor,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: GlassmorphicContainer(
        width: width ?? double.infinity,
        height: height ?? 0,
        borderRadius: borderRadius,
        blur: blur,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.glassBackground.withOpacity(opacity),
            AppColors.glassBackground.withOpacity(opacity * 0.5),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            borderColor ?? AppColors.glassBorder,
            (borderColor ?? AppColors.glassBorder).withOpacity(0.5),
          ],
        ),
        child: Container(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class GlassmorphismCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const GlassmorphismCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 16.0,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderColor,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardWidget = GlassmorphismWidget(
      width: width,
      height: height,
      borderRadius: borderRadius,
      blur: blur,
      opacity: opacity,
      borderColor: borderColor,
      padding: padding,
      margin: margin,
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}

class GlassmorphismButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isEnabled;

  const GlassmorphismButton({
    super.key,
    required this.child,
    this.onPressed,
    this.borderRadius = 12.0,
    this.blur = 8.0,
    this.opacity = 0.15,
    this.borderColor,
    this.padding,
    this.margin,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphismCard(
      borderRadius: borderRadius,
      blur: blur,
      opacity: isEnabled ? opacity : opacity * 0.5,
      borderColor: isEnabled ? borderColor : AppColors.textTertiary,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: margin,
      onTap: isEnabled ? onPressed : null,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.6,
        child: child,
      ),
    );
  }
}

class GlassmorphismAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final double blur;
  final double opacity;

  const GlassmorphismAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.blur = 10.0,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading,
      actions: actions,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: GlassmorphismWidget(
        borderRadius: 0,
        blur: blur,
        opacity: opacity,
        child: Container(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
