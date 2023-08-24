import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/core/routing/router.dart';
import 'package:mobile/core/utils/extensions.dart';
import 'package:mobile/features/auth/domain/entities/auth.result.dart';
import 'package:mobile/features/common/domain/entities/user.dart';
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
  var _loading = false, _maxPhoneNumberLength = 16, _showEditInfo = false;
  final StreamController<UserEntity> _userStreamController =
      StreamController.broadcast(sync: false);

  @override
  void initState() {
    super.initState();
    _userCubit.currentUser();
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

            if (state is SuccessState<Stream<UserEntity>>) {
              _userStreamController.addStream(state.data);
              return;
            }

            if (state is SuccessState<void>) {
              context.navigator.pushNamedAndRemoveUntil(
                  AppRouter.homeRoute, (route) => false);
            }
          },
          child: Scaffold(
            body: StreamBuilder<UserEntity>(
              stream: _userStreamController.stream,
              builder: (context, snapshot) {
                logger.d('snapshot: $snapshot');
                // if (snapshot.connectionState != ConnectionState.active) {
                //   return const SizedBox.shrink();
                // }

                if (snapshot.hasData &&
                    snapshot.data != null &&
                    !_showEditInfo) {
                  _updateUserInfo(snapshot.data!);
                  return _buildUserUI(snapshot.data!);
                }

                return _buildEditInfoUI;
              },
            ),
          ),
        ),
      );

  /// Builds the user UI
  Widget _buildUserUI(UserEntity user) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          if (user.photoUrl.isNullOrEmpty())
            const AppLogo().animate().shimmer(duration: 850.ms)
          else
            user.photoUrl.avatar(size: 120, circular: true),
          AnimatedColumn(
            animateType: AnimateType.slideDown,
            children: [
              tr('welcome_back')
                  .subtitle1(context, emphasis: kEmphasisMedium)
                  .top(48),
              user.name.h5(context),
            ],
          ),
          const Spacer(),
          AnimatedColumn(
            animateType: AnimateType.slideUp,
            duration: 1800,
            children: [
              AppRoundedButton(
                text: tr('get_started'),
                onTap: () => context.navigator.pushNamedAndRemoveUntil(
                    AppRouter.homeRoute, (route) => false),
              ).vertical(16),
              TextButton(
                      onPressed: () => setState(() => _showEditInfo = true),
                      child: tr('edit_info').button(context))
                  .bottom(context.padding.bottom + 16),
            ],
          ),
        ],
      ).horizontal(24).centered();

  /// Builds the edit info UI
  Widget get _buildEditInfoUI => Column(
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
                        validator: (value) =>
                            value!.isEmpty ? tr('full_name_required') : null),
                    FilledTextField(tr('email_label'),
                        controller: _emailController,
                        type: AppTextFieldType.email,
                        enabled: widget.authResult.email.isNullOrEmpty() &&
                            !_loading,
                        verticalPadding: 20,
                        validator: (value) =>
                            value!.isEmpty ? tr('email_required') : null),
                    FilledTextField(tr('password_label'),
                        controller: _passwordController,
                        type: AppTextFieldType.password,
                        enabled: !_loading,
                        verticalPadding: 20,
                        validator: (value) =>
                            value!.isEmpty ? tr('password_required') : null),
                    const Divider().bottom(20),
                    FilledTextField(tr('phone_number_label'),
                        controller: _phoneNumberController,
                        type: AppTextFieldType.phone,
                        hint: "+000 000 000 000",
                        enabled:
                            widget.authResult.phoneNumber.isNullOrEmpty() &&
                                !_loading,
                        verticalPadding: 20,
                        maxLength: _maxPhoneNumberLength,
                        onChanged: (value) {
                          setState(() => _maxPhoneNumberLength =
                              value.startsWith('0') ? 13 : 16);

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
                          child: FilledTextField(tr('credit_card_number_label'),
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
                          child: FilledTextField(tr('credit_card_cvv_label'),
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
      );

  void _validateForm() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      var fullName = _fullNameController.text.trim(),
          email = _emailController.text.trim(),
          phoneNumber = _phoneNumberController.text.replaceAll(' ', '').trim(),
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

  void _updateUserInfo(UserEntity user) {
    _phoneNumberController.text = user.phoneNumber;
    _creditCardNumberController.text = user.creditCardNumber;
    _creditCardExpiryDateController.text = user.creditCardExpiryDate;
    _creditCardCvvController.text = user.creditCardCvv;
    _creditCardZipCodeController.text = user.zipCode;
    _fullNameController.text = user.name;
    _emailController.text = user.email;
  }
}
