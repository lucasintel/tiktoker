require "./creator/*"

module Tiktoker
  struct Tiktok::Creator
    include JSON::Serializable
    include JSON::Serializable::Unmapped

    enum PrivacyToggle
      Everyone
      Friends
      Unknown # FIXME: I'm not sure.
      NoOne
    end

    getter id : String

    @[JSON::Field(key: "shortId")]
    getter short_id : String?

    @[JSON::Field(key: "uniqueId")]
    # Returns the creator username.
    getter unique_id : String

    # Returns the creator name.
    getter nickname : String

    @[JSON::Field(key: "avatarLarger")]
    getter avatar_larger : String?

    @[JSON::Field(key: "avatarMedium")]
    getter avatar_medium : String?

    @[JSON::Field(key: "avatarThumb")]
    getter avatar_thumb : String?

    # Returns the creator signature (aka bio).
    getter signature : String?

    @[JSON::Field(key: "createTime", converter: Time::EpochConverter)]
    getter create_time : Time?

    # Returns the creator verification status.
    getter verified : Bool?

    @[JSON::Field(key: "secUid")]
    # Returns the creator secUid, the user unique identifier.
    getter sec_uid : String

    getter ftc : Bool?

    getter relation : UInt16?

    @[JSON::Field(key: "openFavorite")]
    getter open_favorite : Bool?

    @[JSON::Field(key: "bioLink", root: "link")]
    getter bio_link : String?

    @[JSON::Field(
      key: "commentSetting",
      converter: Enum::ValueConverter(Tiktoker::Tiktok::Creator::PrivacyToggle)
    )]
    getter comment_setting : PrivacyToggle?

    @[JSON::Field(
      key: "duetSetting",
      converter: Enum::ValueConverter(Tiktoker::Tiktok::Creator::PrivacyToggle)
    )]
    getter duet_setting : PrivacyToggle?

    @[JSON::Field(
      key: "stitchSetting",
      converter: Enum::ValueConverter(Tiktoker::Tiktok::Creator::PrivacyToggle)
    )]
    getter stitch_setting : PrivacyToggle?

    @[JSON::Field(key: "privateAccount")]
    getter private_account : Bool?

    getter secret : Bool?

    @[JSON::Field(key: "isADVirtual")]
    getter is_ad_virtual : Bool?

    @[JSON::Field(key: "roomId")]
    getter room_id : String?
  end
end
