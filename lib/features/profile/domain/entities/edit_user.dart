import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class EditUser extends User {
  EditUser({
    User? baseUser,
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? birthDate,
    String? avatarUrl,
    bool? isVerified,
    bool? usesBitmoji,
    String? location,
    String? bio,
    String? gender,
    String? companyName,
  }) : super(
          id: id ?? baseUser?.id ?? userDataStore.user['id'],
          email: email ?? baseUser?.email ?? userDataStore.user['email'],
          firstName: firstName ??
              baseUser?.firstName ??
              userDataStore.user['f_name'] ??
              "",
          lastName: lastName ??
              baseUser?.lastName ??
              userDataStore.user['l_name'] ??
              "",
          phoneNumber: phoneNumber ??
              baseUser?.phoneNumber ??
              userDataStore.user['phone'] ??
              "",
          birthDate: birthDate ??
              baseUser?.birthDate ??
              userDataStore.user['birth_date'],
          avatarUrl: avatarUrl ??
              baseUser?.avatarUrl ??
              userDataStore.user['avatar_url'] ??
              "",
          isVerified: isVerified ??
              baseUser?.isVerified ??
              userDataStore.user['email_verified_at'],
          usesBitmoji: usesBitmoji ??
              baseUser?.usesBitmoji ??
              userDataStore.user['uses_bitmoji'],
          gender: gender ?? baseUser?.gender ?? userDataStore.user['gender'],
          staffId: baseUser?.staffId ?? userDataStore.user['staff_id'],
          companyName: companyName ??
              baseUser?.companyName ??
              userDataStore.user['company_name'],
          location:"",
              // location ?? baseUser?.location ?? userDataStore.user["location"],
          bio: bio ?? baseUser?.bio ?? userDataStore.user["bio"] ?? "",
        );
}
