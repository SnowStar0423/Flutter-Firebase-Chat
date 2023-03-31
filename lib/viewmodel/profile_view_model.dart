import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../utils/app_util.dart';

class ProfileViewModel extends GetxController {
  ProfileViewModel({required this.firebaseAuth});
  final FirebaseAuth firebaseAuth;
  RxBool isUploadingImage = false.obs;
  bool _browsingImage = false;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _selectedImage;
  final _imagePicker = ImagePicker();
  String? _newPhotoUrl;

  @override
  void onInit() {
    super.onInit();
    _newPhotoUrl = firebaseAuth.currentUser!.photoURL;
  }

  saveProfile(String name) async {
    firebaseAuth.currentUser!.updateDisplayName(name);
    await _updateProfilePhotoURL(_newPhotoUrl);
    firebaseAuth.currentUser!.reload();
    update();
  }

  String? getUserPhotoUrl() {
    return firebaseAuth.currentUser!.photoURL;
  }

  String getUserDisplayName() {
    return firebaseAuth.currentUser!.displayName ?? "N/A";
  }

  String getUserEmail() {
    return firebaseAuth.currentUser!.email ?? "N/A";
  }

  Future<bool> uploadFile(File file, String fileName, String filePath) async {
    if (AppUtil.checkIsNull(file) ||
        AppUtil.checkIsNull(fileName) ||
        isUploadingImage.value) {
      return false;
    }
    _setUploadingImage(true);

    var res = storage.ref().child('$filePath/$fileName');

    await res.putFile(file).whenComplete(() async {
      await res.getDownloadURL().then((value) async {
        AppUtil.debugPrint(value);
        _newPhotoUrl = value;
        return true;
        // //==== auto save new profile url
        // return await _updateProfilePhotoURL(value);
      });
    });
    _setUploadingImage(false);
    return false;
  }

  Future<bool> _updateProfilePhotoURL(url) async {
    if (AppUtil.checkIsNull(url)) return false;
    bool res = false;
    try {
      await firebaseAuth.currentUser!.updatePhotoURL(url).then((value) {
        res = true;
      });
    } on FirebaseAuthException catch (e) {
      AppUtil.debugPrint(e.toString());
    }
    return res;
  }

  Future<bool> updateProfile(File file) async {
    bool res = false;

    try {
      if (!AppUtil.checkIsNull(file)) {
        String fileName = firebaseAuth.currentUser!.email!;
        res = await uploadFile(file, fileName, "profileImages");
      }
      await firebaseAuth.currentUser!.reload();
      // firebaseUser = FirebaseAuth.instance.currentUser ?? firebaseUser;
      // await showCustomAlerMessage(context, "Success",
      //     descriptions: "Your profile has been updated.");
    } on FirebaseAuthException catch (e) {
      AppUtil.debugPrint(e);
    }
    return res;
  }

  browseImage() async {
    if (_browsingImage) return;
    _setBrowsingImage(true);

    try {
      final pickedFile =
          await _imagePicker.pickImage(source: ImageSource.gallery);
      if (!AppUtil.checkIsNull(pickedFile?.path)) {
        _selectedImage = File(pickedFile!.path);
        update();
        await updateProfile(_selectedImage!);
        update();
        Get.snackbar("Message", "profile was updated successfully.");
      }
    } catch (e) {
      AppUtil.debugPrint(e);
    } finally {
      _setBrowsingImage(false);
    }
  }

  bool _setUploadingImage(bool val) => isUploadingImage.value = val;
  File? getSelectedImage() => _selectedImage;

  bool _setBrowsingImage(bool val) => _browsingImage = val;
}
