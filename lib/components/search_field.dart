import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchField extends StatefulWidget implements PreferredSizeWidget {
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final String? initialSearch;

  const SearchField({
    super. key,
    this.onChanged,
    this.onSubmit,
    this.initialSearch,
  }) ;

  @override
  Size get preferredSize => const Size.fromHeight(54);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.preferredSize.height,
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      child: TextField(
        controller: _controller,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onInverseSurface,
          // height: 1,
        ),
        decoration: InputDecoration(
          hintText: "search.search".tr(),
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onInverseSurface,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          prefixIcon: Container(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              "assets/Icons/search.svg",
              package: "amity_uikit_beta_service",
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 0, 8, 8),
          suffix: IconButton(
            onPressed: () {
              _controller.clear();
              widget.onSubmit?.call("");
            },
            style: IconButton.styleFrom(
              fixedSize: const Size.square(16),
              iconSize: 16,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
            icon: const Icon(Icons.close),
          ),
        ),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmit,
      ),
    );
  }
}
