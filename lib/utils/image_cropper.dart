import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
 
// Add the below function inside your working class
class imageCropper{

static Future<dynamic> cropImage(File? imageFile) async {
	if (imageFile != null) {
	CroppedFile? cropped = await ImageCropper().cropImage(
		sourcePath: imageFile!.path,
		aspectRatioPresets:
			[
				CropAspectRatioPreset.square,
				CropAspectRatioPreset.ratio3x2,
				CropAspectRatioPreset.original,
				CropAspectRatioPreset.ratio4x3,
				CropAspectRatioPreset.ratio16x9
				],
			
		uiSettings: [
			AndroidUiSettings(
				toolbarTitle: 'Crop',
				cropGridColor: Colors.black,
				initAspectRatio: CropAspectRatioPreset.original,
				lockAspectRatio: false),
			IOSUiSettings(title: 'Crop')
		]);

	if (cropped != null) {
		 
		imageFile = File(cropped.path);
    return imageFile;
	}
  
	}
}

}
