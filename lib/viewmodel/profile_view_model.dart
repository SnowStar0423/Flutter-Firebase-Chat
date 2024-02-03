import 'dart:io';
import 'package:chat_app/core/services/report_service.dart';
import 'package:chat_app/core/services/user_service.dart';
import 'package:chat_app/core/utils/app_global.dart';
import 'package:chat_app/core/utils/firebase_constant.dart';
import 'package:chat_app/model/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:chat_app/core/utils/app_util.dart';

class ProfileViewModel extends GetxController {
  ProfileViewModel({
    required this.firebaseAuth,
    required this.userService,
    required this.firebaseFirestore,
    required this.reportService,
  });

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final UserService userService;
  final ReportService reportService;
  RxBool isUploadingImage = false.obs;
  bool _browsingImage = false;
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _selectedImage;
  final _imagePicker = ImagePicker();
  String? _newPhotoUrl;
  final RxBool _saving = false.obs;

  @override
  void onInit() async {
    super.onInit();

    resetUserProfile();
  }

  bool get saving => _saving.value;
  set saving(bool value) => _saving.value = value;

  Future<bool> saveProfile(String name) async {
    if (saving) return false;
    saving = true;
    bool shouldSave = false;
    try {
      if (name != firebaseAuth.currentUser!.displayName) {
        shouldSave = true;
        await _updateDisplayName(name);
      }
      if (_newPhotoUrl != firebaseAuth.currentUser!.photoURL) {
        shouldSave = true;
        await _updateProfilePhotoURL(_newPhotoUrl);
      }
      await _reloadCurrentUser();
      if (shouldSave) {
        _saveUserProfileToFirestore();
      }
      saving = false;
    } catch (e) {
      AppUtil.debugPrint(e.toString());
      saving = false;
      return false;
    } finally {
      saving = false;
    }
    update();
    return true;
  }

  resetUserProfile() {
    _newPhotoUrl = firebaseAuth.currentUser!.photoURL;
    _selectedImage = null;
  }

  _saveUserProfileToFirestore() async {
    if (firebaseAuth.currentUser == null) return;
    userService.addUser(ChatUser.fromFirebaseUser(
      firebaseAuth.currentUser!,
      AppGlobal.instance.deviceToken,
    ));
  }

  void removeUserPhotoUrl() {
    _newPhotoUrl = null;
    update();
  }

  String? getUserPhotoUrl() {
    return _newPhotoUrl;
  }

  String getUserDisplayName() {
    return firebaseAuth.currentUser!.displayName ?? "N/A";
  }

  String getUserEmail() {
    return firebaseAuth.currentUser!.email ?? "N/A";
  }

  _reloadCurrentUser() async {
    await firebaseAuth.currentUser!.reload();
  }

  Future<bool> _updateDisplayName(name) async {
    if (AppUtil.checkIsNull(name)) return false;
    bool res = false;
    try {
      await firebaseAuth.currentUser!.updateDisplayName(name).then((value) {
        res = true;
      });
    } on FirebaseAuthException catch (e) {
      AppUtil.debugPrint(e.toString());
    }
    return res;
  }

  Future<bool> _updateProfilePhotoURL(url) async {
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
        String fileName = firebaseAuth.currentUser!.uid;
        res = await uploadFile(
            file, fileName, FireStoreConstant.profileImagesPath);
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
      }
    } catch (e) {
      AppUtil.debugPrint(e);
    } finally {
      _setBrowsingImage(false);
    }
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

  bool _setUploadingImage(bool val) => isUploadingImage.value = val;

  File? get selectedImage => _selectedImage;
  bool _setBrowsingImage(bool val) => _browsingImage = val;

  sendFeedback(String data) async {
    reportService.addFeedback(
        userId: firebaseAuth.currentUser!.uid, content: data);
  }
}
