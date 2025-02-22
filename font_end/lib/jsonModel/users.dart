// Create model users
class Users {
    final int? userId;
    final String? userName;
    final String userPassword;
    final String userEmail;
    final String? userPhone;
    final String? userAddress;
    final String? userImage;
    final String? otp;
    final bool? admin;

    Users({
        this.userId,
        this.userName,
        required this.userPassword,
        required this.userEmail,
        this.userPhone,
        this.userAddress,
        this.userImage,
        this.otp,
        this.admin,
    });

    factory Users.fromMap(Map<String, dynamic> json) => Users(
        userId: json["userID"],
        userName: json["userName"],
        userPassword: json["userPassword"],
        userEmail: json["userEmail"],
        userPhone: json["userPhone"],
        userAddress: json["userAddress"],
        userImage: json["userImage"],
        otp: json["otp"],
        admin: json["admin"],
    );

    Map<String, dynamic> toMap() => {
        "userID": userId,
        "userName": userName,
        "userPassword": userPassword,
        "userEmail": userEmail,
        "userPhone": userPhone,
        "userAddress": userAddress,
        "userImage": userImage ??"",
        "otp": otp,
        "admin": admin,
    };
}
