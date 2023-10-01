import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile/generated/assets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_utils/shared_utils.dart';

import 'constants.dart';

extension BuildContextX on BuildContext {
  bool get isDarkMode => theme.brightness == Brightness.dark;

  void showFeatureUnderDevSheet() async => showBarModalBottomSheet(
        context: this,
        backgroundColor: colorScheme.background,
        useRootNavigator: true,
        bounce: true,
        builder: (context) => AnimatedColumn(
          animateType: AnimateType.slideUp,
          children: [
            const SizedBox(height: 24),
            Lottie.asset(Assets.animUnderDev,
                    repeat: false, height: height * 0.2, width: width * 0.7)
                .bottom(24),
            const EmptyContentPlaceholder(
                title: 'You\'re too early',
                subtitle: 'This feature is under development. Stay tuned! 🤩'),
            SafeArea(
              top: false,
              child: AppRoundedButton(
                      text: 'Okay',
                      layoutSize: LayoutSize.standard,
                      onTap: context.navigator.pop)
                  .top(40),
            ),
          ],
        ),
      );

  /// used for custom error messages / prompts
  void showMessageDialog(
    String message, {
    bool showAsError = true,
    String? title,
    String? actionLabel,
    String? animationAsset,
    VoidCallback? onTap,
    IconData? icon,
  }) async {
    if (showAsError) {
      await showBarModalBottomSheet(
        context: this,
        backgroundColor: colorScheme.background,
        useRootNavigator: true,
        bounce: true,
        builder: (context) => AnimatedColumn(
          animateType: AnimateType.slideRight,
          children: [
            Lottie.asset(
                    animationAsset ??
                        (showAsError ? Assets.animError : Assets.animSuccess),
                    frameRate: FrameRate(90),
                    repeat: false,
                    fit: BoxFit.fitHeight,
                    height: height * 0.1,
                    width: width * 0.7)
                .bottom(24),
            AnimatedColumn(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...{
                  Icon(icon, size: 48, color: context.colorScheme.primary)
                      .bottom(16),
                },
                (title ?? context.tr('errors.auth_error_title'))
                    .h6(context,
                        color: context.colorScheme.primary,
                        alignment: TextAlign.center)
                    .bottom(8),
                message.subtitle2(context,
                    alignment: TextAlign.center, emphasis: kEmphasisMedium),
              ],
            ).horizontal(context.width * 0.1).centered(),
            SafeArea(
              top: false,
              child: AppRoundedButton(
                text: actionLabel ?? context.tr('okay'),
                layoutSize: LayoutSize.standard,
                onTap: () {
                  context.navigator.pop();
                  onTap?.call();
                },
              ).top(40),
            ),
          ],
        ).top(24).bottom(padding.bottom + 24),
      );
    } else {
      await showCupertinoModalBottomSheet(
        context: this,
        backgroundColor: colorScheme.background,
        useRootNavigator: true,
        isDismissible: false,
        enableDrag: false,
        bounce: true,
        builder: (context) => AnimatedColumn(
          animateType: AnimateType.slideRight,
          children: [
            Lottie.asset(Assets.animSuccess,
                    frameRate: FrameRate(90),
                    repeat: false,
                    fit: BoxFit.fitHeight,
                    height: height * 0.1,
                    width: width * 0.7)
                .bottom(24),
            AnimatedColumn(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...{
                  Icon(icon, size: 48, color: context.colorScheme.primary)
                      .bottom(16),
                },
                (title ?? 'Successful')
                    .h6(context,
                        color: context.colorScheme.primary,
                        alignment: TextAlign.center)
                    .bottom(8),
                message.subtitle2(context,
                    alignment: TextAlign.center, emphasis: kEmphasisMedium),
              ],
            ).horizontal(context.width * 0.1).centered(),
            SafeArea(
              top: false,
              child: AppRoundedButton(
                text: actionLabel ?? 'Okay',
                layoutSize: LayoutSize.standard,
                onTap: () {
                  context.navigator.pop();
                  onTap?.call();
                },
              ).top(40),
            ),
          ],
        ).top(24).bottom(padding.bottom + 24),
      );
    }
  }
}

extension ScrollX on ScrollController {
  bool get isAtBottom => offset >= position.maxScrollExtent;

  void scrollToBottom() => SchedulerBinding.instance.addPostFrameCallback((_) {
        animateTo(position.maxScrollExtent,
            duration: kDurationFast, curve: Curves.easeOut);
      });

  void scrollToTop() => SchedulerBinding.instance.addPostFrameCallback((_) {
        animateTo(position.minScrollExtent,
            duration: kDurationFast, curve: Curves.easeOut);
      });
}

extension StringX on String? {
  bool get isNumeric => this != null && num.tryParse(this!) != null;

  bool get isCreditCard {
    if (this == null) return false;
    var updatedValue = this!.trim().replaceAll(' ', '');
    return updatedValue.length == 16 && updatedValue.isNumeric;
  }
}
