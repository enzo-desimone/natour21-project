import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:natour21/Accessory_Class/size_config.dart';
import 'package:natour21/Accessory_GUI/theme_color.dart';

import 'boucing_animation.dart';

class CustomTextField {
  late String _hintText;
  late IconData _prefixIcon;
  late IconData _suffixIcon;
  late TextEditingController _controller;
  late bool _haveSuffixIcon;
  late bool _havePrefixIcon;
  late TextInputType _keyBoardType;
  late TextCapitalization _textCapitalization;
  late bool _isObscure;
  late TextInputAction _textInputAction;
  late GlobalKey<FormState> _key;
  late FormFieldValidator<String> _validator;
  late GestureTapCallback _onTapIcon;
  late VoidCallback _onEditingComplete;

  ValueChanged<String>? _onChanged;
  FocusNode? _focusNode;
  VoidCallback? _onTap;
  bool? _readOnly;

  CustomTextField(
      {required hintText,
      required prefixIcon,
      required suffixIcon,
      required controller,
      required haveSuffixIcon,
      required havePrefixIcon,
      required keyBoardType,
      required textCapitalization,
      required isObscure,
      required textInputAction,
      required onEditingComplete,
      required key,
      required validator,
      required onTapIcon,
      focusNode,
      onTap,
      readOnly,
      onChanged}) {
    _hintText = hintText;
    _prefixIcon = prefixIcon;
    _controller = controller;
    _suffixIcon = suffixIcon;
    _haveSuffixIcon = haveSuffixIcon;
    _havePrefixIcon = havePrefixIcon;
    _keyBoardType = keyBoardType;
    _textCapitalization = textCapitalization;
    _isObscure = isObscure;
    _focusNode = focusNode;
    _textInputAction = textInputAction;
    _onEditingComplete = onEditingComplete;
    _key = key;
    _validator = validator;
    _onTapIcon = onTapIcon;
    _onTap = onTap;
    _readOnly = readOnly;
    _onChanged = onChanged;
  }

  Widget showTextField(context) {
    return Form(
      key: _key,
      child: TextFormField(
          autocorrect: false,
          controller: _controller,
          keyboardType: _keyBoardType,
          textCapitalization: _textCapitalization,
          textInputAction: _textInputAction,
          obscureText: _isObscure,
          focusNode: _focusNode,
          onEditingComplete: _onEditingComplete,
          onChanged: _onChanged,
          onTap: _onTap,
          readOnly: _readOnly ?? false,
          style: TextStyle(color: black, fontSize: SizeConfig().h2FontSize),
          decoration: InputDecoration(
              fillColor: grey.withAlpha(130),
              contentPadding: EdgeInsets.only(
                  top: SizeConfig().paddingFifteen,
                  bottom: SizeConfig().paddingFifteen,
                  left: SizeConfig().paddingFifteen),
              filled: true,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(SizeConfig().borderRadiusTwelve),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              hintText: _hintText,
              hintStyle: TextStyle(
                  color: Colors.grey[500], fontSize: SizeConfig().h2FontSize),
              errorStyle: TextStyle(
                  color: Colors.red[700], fontSize: SizeConfig().h4FontSize),
              prefixIcon: Visibility(
                visible: _havePrefixIcon,
                child: Icon(
                  _prefixIcon,
                  size: SizeConfig().iconSize,
                ),
              ),
              suffixIcon: _haveSuffixIcon
                  ? Visibility(
                      visible: _haveSuffixIcon,
                      child: CustomBounce(
                        duration:
                        const Duration(milliseconds: 100),
                        onPressed: _onTapIcon,
                        child: Icon(
                          _suffixIcon,
                          size: SizeConfig().iconSize,
                        ),
                      ),
                    )
                  : null),
          validator: _validator),
    );
  }
}
