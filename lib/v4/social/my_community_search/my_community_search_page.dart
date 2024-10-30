import 'package:amity_uikit_beta_service/v4/core/base_page.dart';
import 'package:amity_uikit_beta_service/v4/social/community_search_result/community_search_result.dart';
import 'package:amity_uikit_beta_service/v4/social/global_search/view_model/global_search_view_model.dart';
import 'package:amity_uikit_beta_service/v4/social/my_community_search/bloc/my_community_search_bloc.dart';
import 'package:amity_uikit_beta_service/v4/social/top_search_bar/top_search_bar.dart';
import 'package:amity_uikit_beta_service/v4/utils/debouncer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AmityMyCommunitiesSearchPage extends NewBasePage {
  AmityMyCommunitiesSearchPage({
    super.key,
    super.pageId = 'social_global_search_page',
  });

  var textController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 300);
  final ScrollController scrollController = ScrollController();
  late AmityGlobalSearchViewModel viewModel;

  @override
  Widget buildPage(BuildContext context) {
    viewModel = AmityGlobalSearchViewModel(
        searchType: AmityGlobalSearchType.myCommunity,
        scrollController: scrollController);
    return BlocProvider(
      create: (_) => MyCommunitySearchBloc(),
      child: BlocBuilder<MyCommunitySearchBloc, MyCommunitySearchState>(
        builder: (context, state) {
          if (state is MyCommunitySearchLoaded) {
            viewModel.updateCommunityModel(
              communities: state.communities,
              isFetching: state.isFetching,
              loadMore: () {
                context
                    .read<MyCommunitySearchBloc>()
                    .add(const MyCommunitySearchLoadMoreEvent());
              },
            );
          }
          return Scaffold(
            backgroundColor: theme.backgroundColor,
            body: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  Column(
                    children: [
                      AmityTopSearchBarComponent(
                        textController: textController,
                        hintText: "community.hint".tr(),
                        onTextChanged: (value) {
                          _debouncer.run(() => context
                                .read<MyCommunitySearchBloc>()
                                .add(MyCommunitySearchTextChanged(value)));
                        },
                      ),
                      if (state is MyCommunitySearchLoaded)
                        Expanded(
                          child: AmityCommunitySearchResultComponent(
                            viewModel: viewModel,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
