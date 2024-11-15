import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final Widget? prefix;
  final String? initialValue;

  const EntryField({
    super.key,
    this.controller,
    this.hint,
    this.prefix,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hint,
        prefix: prefix,
        hintStyle: theme.textTheme.bodyMedium!
            .copyWith(color: theme.hintColor, fontSize: 15),
      ),
    );
  }
}
