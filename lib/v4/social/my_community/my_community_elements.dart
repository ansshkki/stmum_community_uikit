part of 'my_community_component.dart';

class AmityCommunityCategoriesName extends BaseElement {
  final List<String?> tags;

  AmityCommunityCategoriesName({
    super.key,
    super.pageId,
    super.componentId,
    required this.tags,
  }) : super(
            elementId:
                AmityMyCommunityElement.communityCategoryName.stringValue);

  @override
  Widget buildElement(BuildContext context) {
    return getCategoryRow(tags);
  }

  Widget getCategoryRow(List<String?> tags) {
    const int maxTags = 3;
    final int remainingTagsCount = tags.length - maxTags;
    final List<String?> displayedTags = tags.take(maxTags).toList();

    if (remainingTagsCount > 0) {
      displayedTags.add('+$remainingTagsCount');
    }
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final double maxTagWidth =
                (constraints.maxWidth / displayedTags.length)
                    .clamp(0.0, constraints.maxWidth);

            return Wrap(
              spacing: 4.0,
              children: displayedTags.map((tag) {
                return getCategoryWidget(
                    label: tag ?? '', maxWidth: maxTagWidth);
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget getCategoryWidget({
    required String label,
    required double maxWidth,
  }) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: theme.baseColorShade4,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: theme.baseColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class CommunityImageAvatarElement extends BaseElement {
  final String? avatarUrl;
  final String placeHolderPath;

  CommunityImageAvatarElement({
    super.key,
    super.pageId,
    super.componentId,
    this.placeHolderPath =
        "assets/Icons/amity_ic_community_avatar_placeholder.svg",
    required super.elementId,
    required this.avatarUrl,
  });

  @override
  Widget buildElement(BuildContext context) {
    return AmityNetworkImage(
        imageUrl: avatarUrl, placeHolderPath: placeHolderPath);
  }
}

class AmityPrivateBadgeElement extends BaseElement {
  AmityPrivateBadgeElement({
    super.key,
    super.pageId,
    super.componentId,
  }) : super(
            elementId:
                AmityMyCommunityElement.communityPrivateBadge.stringValue);

  @override
  Widget buildElement(BuildContext context) {
    return SvgPicture.asset(
      "assets/Icons/amity_ic_private_badge.svg",
      package: 'amity_uikit_beta_service',
    );
  }
}

class AmityOfficialBadgeElement extends BaseElement {
  AmityOfficialBadgeElement({
    super.key,
    super.pageId,
    super.componentId,
  }) : super(
            elementId:
                AmityMyCommunityElement.communityOfficialBadge.stringValue);

  @override
  Widget buildElement(BuildContext context) {
    return SvgPicture.asset(
      "assets/Icons/amity_ic_official_badge.svg",
      package: 'amity_uikit_beta_service',
    );
  }
}

class CommunityMemberCountElement extends BaseElement {
  final int? memberCount;

  CommunityMemberCountElement({
    super.key,
    super.pageId,
    super.componentId,
    required this.memberCount,
  }) : super(
            elementId:
                AmityMyCommunityElement.communityMemberCount.stringValue);

  @override
  Widget buildElement(BuildContext context) {
    return Text(
      "community.members_pl".plural(
        args: ["${memberCount!.toInt()}"],
        memberCount!.toInt(),
        format: NumberFormat.compact(locale: context.locale.toString()),
      ),
      style: TextStyle(
        color: theme.baseColorShade1,
        fontWeight: FontWeight.w400,
        fontSize: 13,
      ),
    );
  }
}
