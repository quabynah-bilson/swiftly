import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/core/utils/constants.dart';
import 'package:mobile/core/utils/extensions.dart';
import 'package:mobile/core/utils/validator.dart';
import 'package:mobile/features/auth/domain/entities/auth.result.dart';
import 'package:mobile/features/auth/domain/entities/country.dart';
import 'package:mobile/features/auth/domain/entities/phone.auth.response.dart';
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobile/features/common/presentation/widgets/country.picker.dart';
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
  var _loading = false, _maxPhoneNumberLength = 11, _codeSent = false;
  final _pinController = TextEditingController(),
      _authCubit = sl<AuthCubit>(),
      _phoneController = TextEditingController(),
      _formKey = GlobalKey<FormState>();
  String? _verificationId, _countryCode;
  AuthResult? _authResult;
  Country? _selectedCountry;

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
                      title: tr('auth_error_header'));
                }

                if (state is SuccessState<AuthResult>) {
                  setState(() => _codeSent = false);

                  context.navigator.pushNamedAndRemoveUntil(
                      AppRouter.userProfileRoute, (route) => false,
                      arguments: _authResult ?? state.data);
                }

                if (state is SuccessState<PhoneAuthResponse>) {
                  _handlePhoneAuthResponse(state.data);
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
                (_codeSent
                        ? tr('phone_auth_code_sent_header')
                        : tr('phone_auth_header'))
                    .h5(context),
                (_codeSent
                        ? tr('phone_auth_code_sent_desc')
                        : tr('phone_auth_desc'))
                    .subtitle2(context, emphasis: kEmphasisMedium),
                Form(
                  key: _formKey,
                  child: _codeSent
                      ? Pinput(
                          length: 6,
                          controller: _pinController,
                          defaultPinTheme: _pinTheme,
                          keyboardType: TextInputType.number,
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
                          tr('phone_number_label'),
                          hint: tr('phone_number_hint'),
                          countryCode: _selectedCountry?.code ?? '',
                          type: AppTextFieldType.number,
                          enabled: !_loading,
                          controller: _phoneController,
                          validator: Validators.validatePhone,
                          autofocus: true,
                          onTap: _pickCountry,
                          readOnly: _selectedCountry == null,
                          maxLength: _maxPhoneNumberLength,
                          onChanged: (value) {
                            setState(() => _maxPhoneNumberLength =
                                value.startsWith('0')
                                    ? kMaximumPhoneNumberLength
                                    : kMinimumPhoneNumberLength);

                            if (value.length == _maxPhoneNumberLength) {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          prefix: CountryPickerPrefix(
                            country: _selectedCountry,
                            onSelected: (country) =>
                                setState(() => _selectedCountry = country),
                          ),
                        ),
                ).top(40),
                AppRoundedButton(
                  text: _codeSent ? tr('verify_phone') : tr('next'),
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
      _authCubit.signInWithPhoneNumber(
        phoneNumber: _phoneController.text.replaceAll(' ', '').trim(),
        dialCode: _selectedCountry?.dialCode,
      );
    }
  }

  /// Handle phone auth response
  void _handlePhoneAuthResponse(PhoneAuthResponse state) {
    logger.d('PhoneAuthResponse: $state');
    setState(() => _codeSent = state is PhoneAuthResponseCodeSent ||
        state is PhoneAuthResponseCodeAutoRetrievalTimeout);

    if (state is PhoneAuthResponseCodeSent) {
      setState(() => _verificationId = state.verificationId);
    }

    if (state is PhoneAuthResponseCodeAutoRetrievalTimeout) {
      setState(() => _verificationId = state.verificationId);
    }

    if (state is PhoneAuthResponseVerificationFailed) {
      context.showMessageDialog(state.message, title: tr('auth_error_header'));
    }

    if (state is PhoneAuthResponseVerificationCompleted) {
      setState(() => _authResult = state.result);
    }
  }

  Future _pickCountry() async {
    if (_selectedCountry != null) return null;
    var country = await showCountryPickerSheet(context);
    if (country is Country) {
      setState(() => _selectedCountry = country);
    }
  }
}
