class ProfileModel {
  final int userId;
  final String discordId;
  final String discordDisplayName;
  final String? discordAvatarUrl;
  final String? facebookName;
  final String? facebookLink;

  const ProfileModel({
    required this.userId,
    required this.discordId,
    required this.discordDisplayName,
    this.discordAvatarUrl,
    this.facebookName,
    this.facebookLink,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userId: (json['userId'] as num).toInt(),
      discordId: json['discordId'] as String,
      discordDisplayName: json['discordDisplayName'] as String,
      discordAvatarUrl: json['discordAvatarUrl'] as String?,
      facebookName: json['facebookName'] as String?,
      facebookLink: json['facebookLink'] as String?,
    );
  }

  ProfileModel copyWith({String? facebookName, String? facebookLink}) {
    return ProfileModel(
      userId: userId,
      discordId: discordId,
      discordDisplayName: discordDisplayName,
      discordAvatarUrl: discordAvatarUrl,
      facebookName: facebookName ?? this.facebookName,
      facebookLink: facebookLink ?? this.facebookLink,
    );
  }
}
