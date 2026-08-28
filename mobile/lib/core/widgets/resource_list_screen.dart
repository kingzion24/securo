import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/resource_list_cubit.dart';
import '../theme/theme.dart';
import 'panels.dart';
import 'translucent_app_bar.dart';

/// The shared chrome for every simple "fetch a list, show it" drawer screen:
/// translucent app bar, pull-to-refresh, loading skeleton, error-with-retry,
/// and an empty state — so each feature file only supplies what makes it
/// different (the fetch call and one row builder).
class ResourceListScreen<T> extends StatelessWidget {
  const ResourceListScreen({
    required this.title,
    required this.fetch,
    required this.itemBuilder,
    required this.emptyIcon,
    required this.emptyTitle,
    this.emptyMessage,
    this.actions,
    this.header,
    super.key,
  });

  final String title;
  final Future<List<T>> Function() fetch;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final IconData emptyIcon;
  final String emptyTitle;
  final String? emptyMessage;
  final List<Widget>? actions;

  /// Optional content shown above the list, inside the same scroll view
  /// (e.g. a summary card) — built once the data is loaded.
  final Widget Function(BuildContext context, List<T> items)? header;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResourceListCubit<T>(fetch),
      child: _ResourceListView<T>(
        title: title,
        itemBuilder: itemBuilder,
        emptyIcon: emptyIcon,
        emptyTitle: emptyTitle,
        emptyMessage: emptyMessage,
        actions: actions,
        header: header,
      ),
    );
  }
}

class _ResourceListView<T> extends StatelessWidget {
  const _ResourceListView({
    required this.title,
    required this.itemBuilder,
    required this.emptyIcon,
    required this.emptyTitle,
    this.emptyMessage,
    this.actions,
    this.header,
  });

  final String title;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final IconData emptyIcon;
  final String emptyTitle;
  final String? emptyMessage;
  final List<Widget>? actions;
  final Widget Function(BuildContext context, List<T> items)? header;

  @override
  Widget build(BuildContext context) {
    final colors = SecuroTheme.of(context);
    final state = context.watch<ResourceListCubit<T>>().state;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: colors.background,
      extendBodyBehindAppBar: true,
      appBar: TranslucentAppBar(title: title, actions: actions),
      body: switch (state.status) {
        ResourceListStatus.loading => const _ListSkeleton(),
        ResourceListStatus.failure when state.items.isEmpty => ListView(
            padding: EdgeInsets.only(top: kToolbarHeight + 40),
            children: [
              ErrorState(
                message: state.error ?? 'Could not load this',
                onRetry: () => context.read<ResourceListCubit<T>>().load(),
              ),
            ],
          ),
        _ when state.items.isEmpty => ListView(
            padding: EdgeInsets.only(top: kToolbarHeight + 40),
            children: [
              EmptyState(
                icon: emptyIcon,
                title: emptyTitle,
                message: emptyMessage,
              ),
            ],
          ),
        _ => RefreshIndicator(
            onRefresh: () => context.read<ResourceListCubit<T>>().refresh(),
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                kToolbarHeight + MediaQuery.of(context).padding.top + 24,
                16,
                bottomInset + 100,
              ),
              children: [
                if (header != null) ...[
                  header!(context, state.items),
                  const SizedBox(height: 20),
                ],
                SecuroCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (var i = 0; i < state.items.length; i++) ...[
                        if (i > 0) Divider(height: 1, color: colors.border),
                        itemBuilder(context, state.items[i]),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
      },
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          kToolbarHeight + MediaQuery.of(context).padding.top + 24,
          16,
          24,
        ),
        children: [
          SecuroCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                for (var i = 0; i < 5; i++) ...[
                  if (i > 0) const SizedBox(height: 16),
                  Row(
                    children: [
                      const ShimmerBox(width: 36, height: 36, radius: 10),
                      const SizedBox(width: 12),
                      const Expanded(child: ShimmerBox(height: 14)),
                      const SizedBox(width: 12),
                      const ShimmerBox(width: 50, height: 14),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      );
}
