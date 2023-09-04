part of '../home.dart';

class _HomeTab extends StatefulWidget {
  const _HomeTab({super.key});

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  var _loading = false;

  @override
  Widget build(BuildContext context) => LoadingIndicator(
        loadingAnimIsAsset: true,
        lottieAnimResource: Assets.animLoading,
        isLoading: _loading,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: context.padding.top + 8),
          child: AnimatedColumn(
            children: [
              _buildHeader,
              const SizedBox(height: 16),
              _buildSearchBar,
              const SizedBox(height: 16),
              _buildOrderList,
            ],
          ),
        ),
      );

  Widget get _buildOrderList => AnimatedColumn(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              'My Orders'.h6(context),
              IconButton(
                icon: 'See more'.button(context),
                onPressed: _showOrderHistorySheet,
              ),
            ],
          ).horizontal(24),
          const SizedBox(height: 40),
          _buildOrderHistoryList,
        ],
      );

  Widget get _buildSearchBar => GestureDetector(
        onTap: _fakeSearch,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: context.width,
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.circular(40),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              const Icon(TablerIcons.map_pin_search).right(12),
              Expanded(child: 'Tap to track your order'.button(context)),
              const Icon(TablerIcons.chevron_right).left(12),
            ],
          ),
        ),
      );

  Widget get _buildHeader => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Assets.imgAppLogo.asAssetImage(
                height: 28, width: context.width * 0.2, fit: BoxFit.contain),
            IconButton(
              icon: const Icon(TablerIcons.history_toggle),
              tooltip: 'History',
              onPressed: _showOrderHistorySheet,
            ),
          ],
        ),
      );

  // @todo -> implement this
  Widget get _buildOrderHistoryList => AnimatedColumn(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(Assets.animEmptyCart,
              repeat: false,
              height: context.width * 0.3,
              width: context.width * 0.3),
          const SizedBox(height: 16),
          'There are no orders yet'.h6(context),
          'You can start a new order by tapping the cart icon'.subtitle2(
              context,
              emphasis: kEmphasisMedium,
              alignment: TextAlign.center),
        ],
      )
          .top(kToolbarHeight)
          .horizontal(40)
          .bottom(context.padding.bottom + context.height * 0.1);

  void _fakeSearch() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _loading = false);
    context.showMessageDialog(
        'You have no active orders yet. Tap the cart icon to start a new order.',
        title: 'No orders yet');
  }

  void _showOrderHistorySheet() async => await showCupertinoModalBottomSheet(
        context: context,
        backgroundColor: context.colorScheme.background,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            return AnimatedColumn(
              mainAxisSize: MainAxisSize.min,
              animateType: AnimateType.slideUp,
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    'Order History'.h6(context),
                    IconButton(
                      icon: const Icon(TablerIcons.x),
                      onPressed: context.navigator.pop,
                    ),
                  ],
                ).horizontal(16),
                _buildOrderHistoryList,
              ],
            );
          },
        ),
      );
}
