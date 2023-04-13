import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextFormField extends StatelessWidget {
  final String? hintText;
  final String? heading;
  final bool? isMandatory;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onchanged;
  final bool? isPassword;
  final TextStyle? style;
  final bool? isEmail;
  final double? opacity;
  final String? initialvalue;
  final TextEditingController? controller;
  final Key? refkey;
  final Widget? suffixIcon;
  final Function()? ontap;
  final int? maxText;
  final TextInputAction? textAction;
  final Function(String)? onFieldsubmitted;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  final TextInputType? keyboardtype;

  MyTextFormField({
    this.hintText,
    this.initialvalue,
    this.heading,
    this.validator,
    this.onSaved,
    this.isMandatory = true,
    this.isPassword = false,
    this.isEmail = false,
    this.controller,
    this.onchanged,
    this.opacity,
    this.refkey,
    this.suffixIcon,
    this.ontap,
    this.style,
    this.maxText,
    this.textAction,
    this.onFieldsubmitted,
    this.keyboardtype,
    this.focusNode,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity!.toDouble(),
      child: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 10.sp,bottom: 10.sp,right: 25.sp,left: 25.sp),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10.sp),
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text(heading!,
                        style:  TextStyle(
                          color: Colors.black,
                          fontSize: 30.sp,
                        )),
                    Visibility(
                      visible: isMandatory!,
                      child: Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: inputFormatters,
                autocorrect: false,
                maxLength: maxText,
                maxLines: 1,
                onTap: ontap,
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                    fontWeight: FontWeight.w500,
                    fontFamily:
                    Theme.of(context).textTheme.subtitle1!.fontFamily,
                    fontStyle: FontStyle.normal,
                    fontSize: 15),
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  errorBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:  BorderSide(color: Colors.red, width: 0.0),
                  ),
                  // focusedErrorBorder: new OutlineInputBorder(
                  //   borderSide: new BorderSide(color: Colors.red, width: 0.0),
                  // ),
                  suffixIconConstraints:
                  const BoxConstraints(minWidth: 23, maxHeight: 20),
                  errorStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontFamily:
                      Theme.of(context).textTheme.subtitle1!.fontFamily,
                      fontWeight: FontWeight.normal),
                  hintText: hintText,
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                  suffixIcon: suffixIcon,
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:const BorderSide(
                      color: Colors.grey,
                      width: 0.0,
                    ),
                  ),
                  // border: const OutlineInputBorder(),
                ),
                obscureText: isPassword! ? true : false,
                onChanged: onchanged,
                initialValue: initialvalue,
                controller: controller,
                key: refkey,
                onFieldSubmitted: onFieldsubmitted,
                validator: validator,
                onSaved: onSaved,
                keyboardType:
                keyboardtype != null ? keyboardtype : TextInputType.text,
                textInputAction: textAction,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
