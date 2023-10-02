import 'package:easy_localization/easy_localization.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:mobile/core/di/injector.dart';
import 'package:mobile/features/auth/domain/entities/country.dart';
import 'package:mobile/features/auth/presentation/manager/auth_cubit.dart';
import 'package:mobile/generated/assets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_utils/shared_utils.dart';

/// Shows a list of countries to select from
class CountryPickerPrefix extends StatelessWidget {
  final Function(Country) onSelected;
  final Country? country;

  const CountryPickerPrefix({
    super.key,
    required this.onSelected,
    this.country,
  });

  @override
  Widget build(BuildContext context) =>
      country == null ? _buildDefault : _buildSelected;

  /// Builds the default widget
  Widget get _buildDefault => Builder(
        builder: (context) => IconButton(
          onPressed: () async {
            var country = await showCountryPickerSheet(context);
            if (country == null) return;
            onSelected.call(country);
          },
          icon: const HeroIcon(HeroIcons.globeAlt),
        ),
      );

  /// Builds the selected country widget
  Widget get _buildSelected => Builder(
        builder: (context) => GestureDetector(
          onTap: () async {
            var country = await showCountryPickerSheet(context);
            if (country == null) return;
            onSelected.call(country);
          },
          child: AnimatedRow(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FastCachedImage(url: country!.flag, width: 24, height: 24),
              country!.dialCode.subtitle2(context).left(6),
            ],
          ).horizontal(12),
        ),
      );
}

Future<Country?> showCountryPickerSheet(BuildContext context) async {
  final countryCubit = sl<AuthCubit>(),
      searchController = TextEditingController();
  countryCubit.getCountries();
  var filteredCountries = List<Country>.empty(growable: true), loading = true;

  return await showBarModalBottomSheet(
    context: context,
    expand: !loading,
    backgroundColor: context.colorScheme.background,
    builder: (context) => Container(
      color: context.colorScheme.background,
      child: StatefulBuilder(
        builder: (context, setSheetState) => BlocConsumer(
          bloc: countryCubit,
          listener: (context, state) {
            if (state is SuccessState<List<Country>>) {
              filteredCountries = state.data;
              setSheetState(() {});
            }

            setSheetState(() => loading = state is LoadingState);
          },
          builder: (context, state) {
            if (state is ErrorState<String>) {
              return EmptyContentPlaceholder(
                      title: tr('errors.countries_not_found'),
                      subtitle: state.failure)
                  .top(40)
                  .bottom(context.padding.bottom + 24);
            }
            if (state is SuccessState<List<Country>>) {
              var countries = state.data;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  'Select a country'
                      .bodyText1(context)
                      .centered()
                      .top(16)
                      .bottom(8),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: FilledTextField(
                      tr('search'),
                      hint: tr('search_country_hint'),
                      controller: searchController,
                      capitalization: TextCapitalization.sentences,
                      enabled: countries.isNotEmpty,
                      maxLines: 1,
                      keyboardType: TextInputType.name,
                      onChanged: (query) {
                        if (query.isEmpty) {
                          filteredCountries = countries;
                          setSheetState(() {});
                          return;
                        }

                        filteredCountries = countries
                            .where((country) => country.name
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toList();
                        setSheetState(() {});
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final country = filteredCountries[index];
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.colorScheme.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            onTap: () => context.navigator.pop(country),
                            leading: FastCachedImage(
                                url: country.flag, width: 24, height: 24),
                            title: country.name.bodyText1(context),
                            subtitle: country.dialCode.subtitle2(context),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemCount: filteredCountries.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.fromLTRB(20, context.padding.top + 16,
                          20, context.padding.bottom + 24),
                    ),
                  ),
                ],
              );
            }

            return LoadingIndicatorItem(
              loadingAnimationUrl: Assets.animLoading,
              loadingAnimIsAsset: true,
              message: tr('loading_title'),
            ).bottom(context.padding.bottom + 24);
          },
        ),
      ),
    ),
  );
}
