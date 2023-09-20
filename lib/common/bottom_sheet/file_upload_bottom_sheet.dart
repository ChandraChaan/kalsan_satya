import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../utilities/ps_colors.dart';
void FileUploadBottomSheet({required  Function(String type) onCallback}) {
  Get.bottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15))),
      Container(
        color: Colors.white,
        height: 200,
        width: MediaQuery.of(Get.context!)
            .size
            .width,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(
              vertical: 10),
          child: Column(
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty
                          .all(PSColors.app_color)),
                  onPressed: () => onCallback('Cam'),
                  child: const Text(
                      "Camera",
                      style: TextStyle(
                        fontFamily:
                        'Inter',
                        color: Color(
                            0xffffffff),
                        fontSize: 12,
                        fontWeight:
                        FontWeight
                            .w400,
                        fontStyle:
                        FontStyle
                            .normal,
                        letterSpacing: 0,
                      ))),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty
                        .all(PSColors.app_color)),
                onPressed: () => onCallback('Gal'),
                child: const Text(
                  "Gallery",
                  style: TextStyle(
                    color:
                    Color(0xffffffff),
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w400,
                    fontStyle:
                    FontStyle.normal,
                    letterSpacing: 0,
                  ),
                ),
              )
            ],
          ),
        ),
      ));

}

Future<File?> getImageFromCamera() async {
  var image = await ImagePicker.platform
      .pickImage(source: ImageSource.camera, imageQuality: 50);

  if (image != null) {
    return File(image.path);
  } else {
    return null;
    print('No image selected.');
  }

}

Future<File?> getImageFromGallery() async {
  var image = await ImagePicker.platform
      .pickImage(source: ImageSource.gallery, imageQuality: 50);

  if (image != null) {
    return File(image.path);
  } else {
    return null;
    print('No image selected.');
  }

}