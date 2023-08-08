import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/core/utils/extensions.dart';
import 'package:mobile/features/auth/domain/entities/auth.result.dart';
import 'package:mobile/features/common/presentation/manager/user_cubit.dart';
import 'package:mobile/features/common/presentation/widgets/app.logo.dart';
import 'package:mobile/generated/assets.dart';
import 'package:shared_utils/shared_utils.dart';

class UserProfilePage extends StatefulWidget {
  final AuthResult authResult;

  const UserProfilePage({super.key, required this.authResult});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _userCubit = sl<UserCubit>();
  late final _formKey = GlobalKey<FormState>(),
      _fullNameController = TextEditingController(
          text: '${widget.authResult.firstName} ${widget.authResult.lastName}'),
      _emailController = TextEditingController(text: widget.authResult.email),
      _passwordController = TextEditingController(),
      _phoneNumberController =
          TextEditingController(text: widget.authResult.phoneNumber),
      _creditCardNumberController = TextEditingController(),
      _creditCardExpiryDateController = TextEditingController(),
      _creditCardCvvController = TextEditingController(),
      _creditCardZipCodeController = TextEditingController();
  var _loading = false, _maxPhoneNumberLength = 10;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _creditCardNumberController.dispose();
    _creditCardExpiryDateController.dispose();
    _creditCardCvvController.dispose();
    _creditCardZipCodeController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LoadingIndicator(
        isLoading: _loading,
        loadingAnimIsAsset: true,
        lottieAnimResource: Assets.animLoading,
        child: BlocListener(
          bloc: _userCubit,
          listener: (context, state) {
            if (!mounted) return;
            setState(() => _loading = state is LoadingState);

            if (state is ErrorState<String>) {
              context.showMessageDialog(state.failure);
            }

            if (state is SuccessState<void>) {
              context.navigator.pushNamedAndRemoveUntil(
                  AppRouter.homeRoute, (route) => false);
            }
          },
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  width: context.width,
                  padding: EdgeInsets.only(
                      top: context.mediaQuery.padding.top + 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: context.colorScheme.background,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const AppLogo().animate().shimmer(duration: 850.ms),
                      tr('user_profile')
                          .subtitle2(context, alignment: TextAlign.center)
                          .horizontal(context.width * 0.1)
                          .top(8),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          tr('user_profile_desc')
                              .subtitle2(context,
                                  emphasis: kEmphasisMedium,
                                  alignment: TextAlign.center)
                              .top(8),
                          const SizedBox(height: 20),
                          FilledTextField(tr('full_name_label'),
                              controller: _fullNameController,
                              capitalization: TextCapitalization.words,
                              verticalPadding: 20,
                              enabled: !_loading,
                              validator: (value) => value!.isEmpty
                                  ? tr('full_name_required')
                                  : null),
                          FilledTextField(tr('email_label'),
                              controller: _emailController,
                              type: AppTextFieldType.email,
                              enabled:
                                  widget.authResult.email.isNullOrEmpty() &&
                                      !_loading,
                              verticalPadding: 20,
                              validator: (value) =>
                                  value!.isEmpty ? tr('email_required') : null),
                          FilledTextField(tr('password_label'),
                              controller: _passwordController,
                              type: AppTextFieldType.password,
                              enabled: !_loading,
                              verticalPadding: 20,
                              validator: (value) => value!.isEmpty
                                  ? tr('password_required')
                                  : null),
                          const Divider().bottom(20),
                          FilledTextField(tr('phone_number_label'),
                              controller: _phoneNumberController,
                              type: AppTextFieldType.phone,
                              hint: "000-000-000",
                              enabled: widget.authResult.phoneNumber
                                      .isNullOrEmpty() &&
                                  !_loading,
                              verticalPadding: 20,
                              maxLength: _maxPhoneNumberLength,
                              onChanged: (value) {
                                if (value.startsWith('0')) {
                                  _maxPhoneNumberLength = 10;
                                } else {
                                  _maxPhoneNumberLength = 12;
                                }
                                setState(() {});

                                if (value.length == _maxPhoneNumberLength) {
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              validator: (value) => value!.isEmpty
                                  ? tr('phone_number_required')
                                  : null),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: FilledTextField(
                                    tr('credit_card_number_label'),
                                    hint: "XXXX XXXX XXXX XXXX",
                                    controller: _creditCardNumberController,
                                    type: AppTextFieldType.creditCardNumber,
                                    enabled: !_loading,
                                    verticalPadding: 20,
                                    validator: (value) => value!.isEmpty
                                        ? tr('credit_card_number_required')
                                        : null),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: FilledTextField(
                                    tr('credit_card_expiry_date_label'),
                                    hint: "MM/YY",
                                    controller: _creditCardExpiryDateController,
                                    type: AppTextFieldType.creditCardExpiry,
                                    enabled: !_loading,
                                    verticalPadding: 20,
                                    validator: (value) => value!.isEmpty
                                        ? tr('credit_card_expiry_date_required')
                                        : null),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: FilledTextField(
                                    tr('credit_card_cvv_label'),
                                    hint: "XXX",
                                    controller: _creditCardCvvController,
                                    type: AppTextFieldType.creditCardCvv,
                                    enabled: !_loading,
                                    verticalPadding: 20,
                                    validator: (value) => value!.isEmpty
                                        ? tr('credit_card_cvv_required')
                                        : null),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: FilledTextField(
                                    tr('credit_card_zip_code_label'),
                                    hint: "XXXXX",
                                    controller: _creditCardZipCodeController,
                                    type: AppTextFieldType.number,
                                    enabled: !_loading,
                                    verticalPadding: 20,
                                    validator: (value) => value!.isEmpty
                                        ? tr('credit_card_zip_code_required')
                                        : null),
                              ),
                            ],
                          ),
                          AppRoundedButton(
                              text: tr('lets_go'),
                              onTap: _validateForm,
                              layoutSize: LayoutSize.standard,
                              enabled: !_loading),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void _validateForm() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      var fullName = _fullNameController.text.trim(),
          email = _emailController.text.trim(),
          phoneNumber = _phoneNumberController.text.trim(),
          creditCardNumber = _creditCardNumberController.text.trim(),
          creditCardExpiryDate = _creditCardExpiryDateController.text.trim(),
          creditCardCvv = _creditCardCvvController.text.trim(),
          password = _passwordController.text.trim(),
          creditCardZipCode = _creditCardZipCodeController.text.trim();

      _userCubit.createUser(
        name: fullName,
        email: email,
        password: password,
        photoUrl: widget.authResult.photoUrl,
        phoneNumber: phoneNumber,
        creditCardNumber: creditCardNumber,
        creditCardExpiryDate: creditCardExpiryDate,
        creditCardCvv: creditCardCvv,
        zipCode: creditCardZipCode,
      );
    }
  }
}
