import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:love_connection/Widgets/custom_image.dart';
import '../../main.dart';

class CustomImageSelector<T extends GetxController> extends StatefulWidget {
  final double? height;
  final double? width;
  final double? radius;
  final Color? color;
  final Icon? icon;
  final String? image;
  final T controller;
  final bool isUpdate;
  const CustomImageSelector(
      {super.key,
      this.height,
      this.width,
      this.radius,
      this.color,
      this.icon,
      this.image,
      required this.controller,
      this.isUpdate = false});
  @override
  State<CustomImageSelector> createState() => _CustomImageSelectorState<T>();
}

class _CustomImageSelectorState<T extends GetxController>
    extends State<CustomImageSelector<T>> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      init: widget.controller,
      builder: (imageController) {
        // Cast controller to its specific type
        final typedController = imageController as dynamic;
        return InkWell(
          onTap: () async {
            if (typedController.appImagePicker != null) {
              await typedController.appImagePicker(widget.isUpdate);
            } else {
              print("Error: imagePicker is not defined in the controller.");
            }
          },
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(widget.radius ?? 0.r),
            ),
            child: typedController.updateImageFile == null && widget.isUpdate
                ? CustomImage(
                    width: 50,
                    height: 50,
                    image: widget.image,
                    isNetwork: true,
                  )
                : widget.isUpdate
                    ? ClipRRect(
                        child: typedController.updateImageFile == null
                            ? widget.icon
                            : Image.file(
                                typedController.updateImageFile!,
                                fit: BoxFit.cover,
                              ))
                    : ClipRRect(
                        child: typedController.imageFile == null
                            ? widget.icon
                            : Image.file(
                                typedController.imageFile!,
                                fit: BoxFit.cover,
                              )),
          ),
        );
      },
    );
  }
}
