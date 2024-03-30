// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  static Future<void> singUpWithEmailAndPassword(email, password) async {
    final auth = FirebaseAuth.instance;
    await auth.createUserWithEmailAndPassword(
        email: email,
        password:
            password); //Tạo một tham chiếu tới đối tượng FirebaseAuth thông qua FirebaseAuth.instance. Điều này cho phép truy cập đến các phương thức xác thực của Firebase.
  }

// static Future<void> singUpWithEmailAndPassword(email, password) async {: Đây là khai báo phương thức singUpWithEmailAndPassword, dùng để đăng ký người dùng mới bằng cách cung cấp email và mật khẩu. Phương thức này là static, nghĩa là có thể gọi trực tiếp từ lớp mà không cần tạo thể hiện của lớp AuthRepo.
  static Future<void> singInWithEmailAndPassword(email, password) async {
    //Tương tự như trên, đây là phương thức để đăng nhập người dùng bằng email và mật khẩu.
    final auth = FirebaseAuth.instance;
    await auth.signInWithEmailAndPassword(
        email: email,
        password:
            password); // Sử dụng phương thức createUserWithEmailAndPassword của đối tượng auth để tạo một người dùng mới bằng cách cung cấp email và mật khẩu.
  }

  static Future<void> sendEmailVerification() async {
    //Đây là phương thức gửi email xác thực cho người dùng đã đăng nhập.
    User user = FirebaseAuth.instance
        .currentUser!; //Lấy người dùng hiện tại thông qua currentUser của FirebaseAuth. Sử dụng dấu ! để khẳng định rằng currentUser không bao giờ trả về giá trị null trong ngữ cảnh này.
    try {
      await user
          .sendEmailVerification(); //Sử dụng phương thức sendEmailVerification của đối tượng người dùng để gửi email xác thực
    } catch (e) {
      print(e);
    }
  }

  static get uid {
    User user = FirebaseAuth.instance.currentUser!;
    return user.uid;
  }
  //Đây là một getter method có tên uid, dùng để lấy ID của người dùng hiện tại. Phương thức này trả về ID của người dùng thông qua thuộc tính uid của đối tượng User.

  static Future<void> updateUserName(displayName) async {
    User user = FirebaseAuth.instance.currentUser!;
    await user.updateDisplayName(displayName);
  }

// Phương thức này dùng để cập nhật tên hiển thị của người dùng. Nó nhận vào đối số displayName là tên mới cần cập nhật và sau đó gọi phương thức updateDisplayName của đối tượng User để thực hiện việc cập nhật.
  static Future<void> updateProfileImage(profileImage) async {
    User user = FirebaseAuth.instance.currentUser!;

    await user.updatePhotoURL(profileImage);
  }

//Tương tự như phương thức trên, phương thức này dùng để cập nhật hình ảnh đại diện của người dùng. Nó nhận vào đối số profileImage là URL của hình ảnh mới và sau đó gọi phương thức updatePhotoURL của đối tượng User để thực hiện việc cập nhật.
  static Future<void> reloadUserData() async {
    await FirebaseAuth.instance.currentUser!.reload();
  }

// Phương thức này dùng để tải lại dữ liệu người dùng hiện tại từ máy chủ. Nó gọi phương thức reload của đối tượng currentUser.
  static Future<bool> checkEmailVerification() async {
    try {
      bool emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      return emailVerified == true;
    } catch (e) {
      print(e);
      return false;
    }
  }
  //Phương thức này kiểm tra xem email của người dùng đã được xác minh chưa. Nó trả về true nếu email đã được xác minh và false nếu không. Phương thức này sử dụng thuộc tính emailVerified của đối tượng currentUser để kiểm tra.

  static Future<void> logOut() async {
    final auth = FirebaseAuth.instance;
    await auth.signOut();
  }
  //Phương thức này dùng để đăng xuất người dùng hiện tại bằng cách gọi phương thức signOut của đối tượng FirebaseAuth.

  static Future<void> sendPasswordResetEmail(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }
  //Phương thức này gửi email để đặt lại mật khẩu cho địa chỉ email đã cung cấp. Nó sử dụng phương thức sendPasswordResetEmail của đối tượng FirebaseAuth.

  static Future<bool> checkOldPassword(email, password) async {
    AuthCredential authCredential =
        EmailAuthProvider.credential(email: email, password: password);
    try {
      var credentialResult = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(authCredential);
      return credentialResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //Phương thức này kiểm tra xem mật khẩu cũ của người dùng có đúng không. Nó sử dụng phương thức reauthenticateWithCredential của đối tượng currentUser để xác thực người dùng và trả về true nếu mật khẩu cũ đúng và false nếu không đúng.

  static Future<void> updateUserPassword(newPassword) async {
    User user = FirebaseAuth.instance.currentUser!;
    try {
      await user.updatePassword(newPassword);
    } catch (e) {
      print(e);
    }
  }
}

//Phương thức này dùng để cập nhật mật khẩu mới cho người dùng. Nó nhận vào đối số newPassword là mật khẩu mới và sau đó gọi phương thức updatePassword của đối tượng User để thực hiện việc cập nhật.
