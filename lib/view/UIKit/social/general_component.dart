import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AmityGeneralComponent {
  static void showOptionsBottomSheet(
      BuildContext context, List<Widget> listTiles) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsetsDirectional.only(top: 20, bottom: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Wrap(
            children: listTiles,
          ),
        );
      },
    );
  }
}

class TimeAgoWidget extends StatelessWidget {
  final DateTime createdAt; // Assuming createdAt is a DateTime object
  final Color? textColor;

  const TimeAgoWidget({super.key, required this.createdAt, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDate(context, createdAt),
      style: TextStyle(
        fontSize: 12,
        color: textColor ?? Colors.grey,
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    DateTime localDate = date.toLocal();
    Duration difference = DateTime.now().difference(localDate);

    // Calculate the difference in weeks, months, and years
    int weeks = (difference.inDays / 7).floor();
    int months = (difference.inDays / 30).floor(); // Approximation
    int years = (difference.inDays / 365).floor(); // Approximation

    if (years > 0) {
      return "time.year".plural(
        years,
        format: NumberFormat.compact(locale: context.locale.toString()),
      ); //year
    } else if (months > 0) {
      return "time.month".plural(
        months,
        format: NumberFormat.compact(locale: context.locale.toString()),
      );
    } else if (weeks > 0) {
      return "time.week".plural(
        weeks,
        format: NumberFormat.compact(locale: context.locale.toString()),
      );
    } else if (difference.inDays > 0) {
      return "time.day".plural(
        difference.inDays,
        format: NumberFormat.compact(locale: context.locale.toString()),
      );
    } else if (difference.inHours > 0) {
      return "time.hour".plural(
        difference.inHours,
        format: NumberFormat.compact(locale: context.locale.toString()),
      );
    } else if (difference.inMinutes > 0) {
      return "time.minute".plural(
        difference.inMinutes,
        format: NumberFormat.compact(locale: context.locale.toString()),
      );
    } else {
      return "time.now".tr(); //Just now
    }
  }
}
