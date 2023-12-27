import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodySmall8 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 8.fSize,
      );
  static get bodySmallMontserrat => theme.textTheme.bodySmall!.montserrat;
  static get bodySmallMontserratOnPrimaryContainer =>
      theme.textTheme.bodySmall!.montserrat.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );
  static get bodySmallMontserratOnPrimaryContainer8 =>
      theme.textTheme.bodySmall!.montserrat.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 8.fSize,
      );
  // Title text style
  static get titleSmallMontserratBlack900 =>
      theme.textTheme.titleSmall!.montserrat.copyWith(
        color: appTheme.black900,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w700,
      );
  static get titleSmallMontserratBlack900Bold =>
      theme.textTheme.titleSmall!.montserrat.copyWith(
        color: appTheme.black900,
        fontSize: 15.fSize,
        fontWeight: FontWeight.w700,
      );
}

extension on TextStyle {
  TextStyle get montserrat {
    return copyWith(
      fontFamily: 'Montserrat',
    );
  }

}
