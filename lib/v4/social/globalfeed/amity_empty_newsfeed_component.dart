import 'package:amity_uikit_beta_service/v4/core/base_element.dart';
import 'package:amity_uikit_beta_service/v4/social/social_home_page/bloc/social_home_bloc.dart';
import 'package:amity_uikit_beta_service/v4/social/social_home_page/bloc/social_home_event.dart';
import 'package:amity_uikit_beta_service/view/UIKit/social/create_community_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AmityEmptyNewsFeedComponent extends BaseElement {
  AmityEmptyNewsFeedComponent({super.key, required super.elementId});

  @override
  Widget buildElement(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(),
            child: SvgPicture.asset(
              'assets/Icons/amity_ic_global_feed_empty.svg',
              package: 'amity_uikit_beta_service',
              width: 160,
              height: 160,
            ),
          ),
          SizedBox(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 252,
                        child: Text(
                          "feed.empty".tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.baseColorShade1,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "community.find".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.baseColorShade1,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 17),
                SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => context
                            .read<SocialHomeBloc>()
                            .add(TabSelectedEvent(1)),
                        child: Container(
                          width: 220,
                          padding: const EdgeInsetsDirectional.only(
                            top: 10,
                            start: 12,
                            end: 16,
                            bottom: 10,
                          ),
                          decoration: ShapeDecoration(
                            color: theme.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      child: SvgPicture.asset(
                                        'assets/Icons/amity_ic_globe.svg.svg',
                                        package: 'amity_uikit_beta_service',
                                        width: 20,
                                        height: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "community.initialize_community".tr(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CreateCommunityPage()),
                        ),
                        child: Container(
                          width: 220,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "community.create".tr(),
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
