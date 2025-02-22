import 'package:amity_uikit_beta_service/viewmodel/configuration_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextFieldWithCounter extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  final int maxCharacters;
  final bool showCount;
  final bool isRequired;
  final TextInputType keyboardType;
  final int? maxLines;
  final void Function()? onTap;

  const TextFieldWithCounter({
    super. key,
    required this.controller,
    required this.title,
    required this.hintText,
    required this.maxCharacters,
    this.showCount = true,
    this.isRequired = true,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.onTap,
  });

  @override
  _TextFieldWithCounterState createState() => _TextFieldWithCounterState();
}

class _TextFieldWithCounterState extends State<TextFieldWithCounter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: widget.title,
                style: Provider.of<AmityUIConfiguration>(context, listen: false)
                    .titleTextStyle
                    .copyWith(
                        color: Provider.of<AmityUIConfiguration>(context)
                            .appColors
                            .base),
                children: [
                  TextSpan(
                    text: widget.isRequired ? ' *' : "",
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            widget.showCount
                ? Container(
                    padding:
                        const EdgeInsetsDirectional.symmetric(vertical: 8.0),
                    child: Text(
                      '${widget.controller.text.length}/${widget.maxCharacters}',
                      style: TextStyle(
                          fontSize: 13.4,
                          color: Provider.of<AmityUIConfiguration>(context)
                              .appColors
                              .base),
                    ),
                  )
                : Container(),
          ],
        ),
        TextField(
          style: TextStyle(
              color: Provider.of<AmityUIConfiguration>(context).appColors.base),
          controller: widget.controller,
          decoration: InputDecoration(
            // hintStyle: TextStyle(
            //     color:
            //         Provider.of<AmityUIConfiguration>(context).appColors.base),
            border: InputBorder.none,
            hintText: widget.hintText,
            counterText: '',
          ),
          cursorColor: Provider.of<AmityUIConfiguration>(context).primaryColor,
          maxLength: widget.maxCharacters,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          onTap: widget.onTap,
          readOnly: widget.onTap != null,
          onChanged: (text) {
            setState(() {});
          },
        ),
        Divider(color: Colors.grey[200], thickness: 1),
      ],
    );
  }
}
