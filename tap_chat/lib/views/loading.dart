import 'package:flutter/material.dart';
import 'package:tap_chat/views/theme_colors.dart';

class Loading extends StatelessWidget {
  const Loading();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(ThemeColors.accent),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
