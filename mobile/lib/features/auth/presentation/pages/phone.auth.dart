import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/core/utils/extensions.dart';
import 'package:mobile/core/utils/validator.dart';
import 'package:mobile/features/auth/domain/entities/phone.auth.response.dart';
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobile/generated/assets.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_utils/shared_utils.dart';

/// Phone authentication page
class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  var _loading = false, _codeSent = false, _showUsername = false;
  final _pinController = TextEditingController(),
      _authCubit = AuthCubit(),
      _updateUsernameCubit = AuthCubit(),
      _phoneController = TextEditingController(),
      _usernameController = TextEditingController(),
      _formKey = GlobalKey<FormState>();
  String? _verificationId;

  PinTheme get _pinTheme => PinTheme(
        width: context.width * 0.15,
        height: context.width * 0.15,
        textStyle: context.textTheme.titleMedium
            ?.copyWith(color: context.colorScheme.onSurface),
        decoration: BoxDecoration(
            color: context.colorScheme.surfaceVariant, shape: BoxShape.circle),
      );

  Widget get _cursor => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 12,
          height: 1,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: context.colorScheme.onSurface,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => LoadingIndicator(
        lottieAnimResource: Assets.animLoading,
        loadingAnimIsAsset: true,
        isLoading: _loading,
        child: MultiBlocListener(
          listeners: [
            BlocListener(
              bloc: _authCubit,
              listener: (context, state) {
                if (!mounted) return;

                setState(() => _loading = state is LoadingState);

                if (state is ErrorState<String>) {
                  if (_codeSent) _phoneController.clear();
                  context.showMessageDialog(state.failure,
                      title: context.tr('auth_error_header'));
                }

                if (state is SuccessState<bool>) {
                  setState(() {
                    _showUsername = state.data;
                    _codeSent = false;
                  });

                  if (!state.data) {
                    context.navigator.pushNamedAndRemoveUntil(
                        AppRouter.homeRoute, (route) => false);
                  }
                }

                if (state is SuccessState<PhoneAuthResponse>) {
                  _handlePhoneAuthResponse(state.data);
                }
              },
            ),
            BlocListener(
              bloc: _updateUsernameCubit,
              listener: (context, state) {
                if (!mounted) return;

                setState(() => _loading = state is LoadingState);

                if (state is SuccessState<String>) {
                  context.navigator.pushNamedAndRemoveUntil(
                      AppRouter.homeRoute, (route) => false);
                }
              },
            ),
          ],
          child: Scaffold(
            appBar: AppBar(),
            body: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.fromLTRB(
                  20, context.mediaQuery.padding.top, 20, 0),
              children: [
                (_showUsername
                        ? context.tr('change_username_header')
                        : _codeSent
                            ? context.tr('phone_auth_code_sent_header')
                            : context.tr('phone_auth_header'))
                    .h5(context),
                (_showUsername
                        ? context.tr('change_username_desc')
                        : _codeSent
                            ? context.tr('phone_auth_code_sent_desc')
                            : context.tr('phone_auth_desc'))
                    .subtitle2(context, emphasis: kEmphasisMedium),
                Form(
                  key: _formKey,
                  child: _showUsername
                      ? FilledTextField(
                          context.tr('username_label'),
                          hint: context.tr('username_hint'),
                          capitalization: TextCapitalization.words,
                          enabled: !_loading,
                          controller: _usernameController,
                          validator: Validators.validate,
                          autofocus: true,
                          prefix: const HeroIcon(HeroIcons.faceSmile),
                        )
                      : _codeSent
                          ? Pinput(
                              length: 6,
                              controller: _pinController,
                              defaultPinTheme: _pinTheme,
                              autofocus: true,
                              separatorBuilder: (_) => const SizedBox(width: 16),
                              focusedPinTheme: _pinTheme.copyWith(
                                decoration: BoxDecoration(
                                  color: context.colorScheme.surface,
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(
                                          0, 0, 0, 0.05999999865889549),
                                      offset: Offset(0, 3),
                                      blurRadius: 16,
                                    )
                                  ],
                                ),
                              ),
                              androidSmsAutofillMethod:
                                  AndroidSmsAutofillMethod.smsUserConsentApi,
                              onCompleted: (value) {
                                if (value.length == 6 && value.isNumeric) {
                                  _authCubit.verifyOTPForPhoneNumber(
                                      verificationId: _verificationId ?? 'n/a',
                                      otp: value);
                                }
                              },
                              showCursor: true,
                              cursor: _cursor,
                            )
                          : FilledTextField(
                              context.tr('phone_number_label'),
                              hint: context.tr('phone_number_hint'),
                              type: AppTextFieldType.phone,
                              enabled: !_loading,
                              controller: _phoneController,
                              validator: Validators.validatePhone,
                              autofocus: true,
                              prefix: const HeroIcon(HeroIcons.phone),
                            ),
                ).top(40),
                AppRoundedButton(
                  text: _showUsername
                      ? context.tr('save')
                      : _codeSent
                          ? context.tr('verify_phone')
                          : context.tr('next'),
                  onTap: _validateForm,
                  enabled: !_loading,
                  layoutSize: LayoutSize.standard,
                ).centered().top(40),
              ],
            ),
          ),
        ),
      );

  /// Validate form
  void _validateForm() {
    if (_codeSent) {
      _authCubit.verifyOTPForPhoneNumber(
          verificationId: _verificationId ?? 'n/a',
          otp: _pinController.text.trim());
      return;
    }

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      if (_showUsername) {
        _updateUsernameCubit.updateUsername(_usernameController.text.trim());
      } else {
        _authCubit.signInWithPhoneNumber(_phoneController.text.trim());
      }
    }
  }

  /// Handle phone auth response
  void _handlePhoneAuthResponse(PhoneAuthResponse state) {
    setState(() => _codeSent = state is PhoneAuthResponseCodeSent ||
        state is PhoneAuthResponseCodeAutoRetrievalTimeout);
    if (state is PhoneAuthResponseCodeSent) {
      setState(() => _verificationId = state.verificationId);
    }

    if (state is PhoneAuthResponseCodeAutoRetrievalTimeout) {
      setState(() => _verificationId = state.verificationId);
    }

    if (state is PhoneAuthResponseVerificationFailed) {
      context.showMessageDialog(state.message,
          title: context.tr('auth_error_header'));
    }

    if (state is PhoneAuthResponseVerificationCompleted) {
      setState(() => _showUsername = state.displayName.isNullOrEmpty());
    }
  }
}
