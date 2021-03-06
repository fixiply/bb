// Internal package
import 'package:bb/utils/constants.dart';
import 'package:bb/helpers/date_helper.dart';

// External package
import 'package:firebase_auth/firebase_auth.dart';

class UserModel<T> {
  String? uuid;
  DateTime? inserted_at;
  DateTime? updated_at;
  String? full_name;
  String? email;
  User? user;
  Roles? role;
  String? company;

  UserModel({
    this.uuid,
    this.inserted_at,
    this.updated_at,
    this.full_name,
    this.email,
    this.user,
    this.role = Roles.customer,
    this.company
  }) {
    if(inserted_at == null) { inserted_at = DateTime.now(); }
  }

  bool isAdmin() {
    return role != null && role == Roles.admin;
  }

  bool isEditor() {
    return role != null && (role == Roles.editor || role == Roles.admin);
  }

  void fromMap(Map<String, dynamic> map) {
    if (map.containsKey('uuid')) this.uuid = map['uuid'];
    this.inserted_at = DateHelper.parse(map['inserted_at']);
    this.updated_at = DateHelper.parse(map['updated_at']);
    this.full_name = map['full_name'];
    this.email = map['email'];
    this.role = Roles.values.elementAt(map['role']);
    this.company = map['company'];
  }

  Map<String, dynamic> toMap({bool persist : false}) {
    Map<String, dynamic> map = {
      'inserted_at': this.inserted_at!.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
      'full_name': this.full_name,
      'email': this.email,
      'role': this.role!.index,
      'company': company,
    };
    if (persist == true) {
      map.addAll({'uuid': this.uuid});
    }
    return map;
  }

  UserModel copy() {
    return UserModel(
      uuid: this.uuid,
      inserted_at: this.inserted_at,
      updated_at: this.updated_at,
      full_name: this.full_name,
      email: this.email,
      user: this.user,
      role: this.role,
      company: this.company,
    );
  }

  // ignore: hash_and_equals
  bool operator ==(other) {
    return (other is UserModel && other.uuid == uuid);
  }

  @override
  String toString() {
    return 'Role: $role, UUID: $uuid';
  }
}
