# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 0) do
  create_schema "vectors"

  # These are extensions that must be enabled in order to support this database
  enable_extension "cube"
  enable_extension "earthdistance"
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"
  enable_extension "vchord"
  enable_extension "vector"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "asset_visibility_enum", ["archive", "timeline", "hidden", "locked"]
  create_enum "assets_status_enum", ["active", "trashed", "deleted"]
  create_enum "sourcetype", ["machine-learning", "exif", "manual"]

  create_table "activity", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.uuid "albumId", null: false
    t.uuid "userId", null: false
    t.uuid "assetId"
    t.text "comment"
    t.boolean "isLiked", default: false, null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["albumId"], name: "IDX_1af8519996fbfb3684b58df280"
    t.index ["assetId", "userId", "albumId"], name: "IDX_activity_like", unique: true, where: "(\"isLiked\" = true)"
    t.index ["assetId"], name: "IDX_8091ea76b12338cb4428d33d78"
    t.index ["updateId"], name: "IDX_activity_update_id"
    t.index ["userId"], name: "IDX_3571467bcbe021f66e2bdce96e"
    t.check_constraint "comment IS NULL AND \"isLiked\" = true OR comment IS NOT NULL AND \"isLiked\" = false", name: "CHK_2ab1e70f113f450eb40c1e3ec8"
  end

  create_table "album_users_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "albumId", null: false
    t.uuid "userId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["albumId"], name: "IDX_album_users_audit_album_id"
    t.index ["deletedAt"], name: "IDX_album_users_audit_deleted_at"
    t.index ["userId"], name: "IDX_album_users_audit_user_id"
  end

  create_table "albums", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "ownerId", null: false
    t.string "albumName", default: "Untitled Album", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.uuid "albumThumbnailAssetId", comment: "Asset ID to be used as thumbnail"
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.text "description", default: "", null: false
    t.timestamptz "deletedAt"
    t.boolean "isActivityEnabled", default: true, null: false
    t.string "order", default: "desc", null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["albumThumbnailAssetId"], name: "IDX_05895aa505a670300d4816debc"
    t.index ["ownerId"], name: "IDX_b22c53f35ef20c28c21637c85f"
    t.index ["updateId"], name: "IDX_albums_update_id"
  end

  create_table "albums_assets_assets", primary_key: ["albumsId", "assetsId"], force: :cascade do |t|
    t.uuid "albumsId", null: false
    t.uuid "assetsId", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.index ["albumsId"], name: "IDX_e590fa396c6898fcd4a50e4092"
    t.index ["assetsId"], name: "IDX_4bd1303d199f4e72ccdf998c62"
  end

  create_table "albums_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "albumId", null: false
    t.uuid "userId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["albumId"], name: "IDX_albums_audit_album_id"
    t.index ["deletedAt"], name: "IDX_albums_audit_deleted_at"
    t.index ["userId"], name: "IDX_albums_audit_user_id"
  end

  create_table "albums_shared_users_users", primary_key: ["albumsId", "usersId"], force: :cascade do |t|
    t.uuid "albumsId", null: false
    t.uuid "usersId", null: false
    t.string "role", default: "editor", null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.index ["albumsId"], name: "IDX_427c350ad49bd3935a50baab73"
    t.index ["updateId"], name: "IDX_album_users_update_id"
    t.index ["usersId"], name: "IDX_f48513bf9bccefd6ff3ad30bd0"
  end

  create_table "api_keys", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "key", null: false
    t.uuid "userId", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.string "permissions", null: false, array: true
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["updateId"], name: "IDX_api_keys_update_id"
    t.index ["userId"], name: "IDX_6c2e267ae764a9413b863a2934"
  end

  create_table "asset_faces", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "assetId", null: false
    t.uuid "personId"
    t.integer "imageWidth", default: 0, null: false
    t.integer "imageHeight", default: 0, null: false
    t.integer "boundingBoxX1", default: 0, null: false
    t.integer "boundingBoxY1", default: 0, null: false
    t.integer "boundingBoxX2", default: 0, null: false
    t.integer "boundingBoxY2", default: 0, null: false
    t.enum "sourceType", default: "machine-learning", null: false, enum_type: "sourcetype"
    t.timestamptz "deletedAt"
    t.index ["assetId", "personId"], name: "IDX_asset_faces_assetId_personId"
    t.index ["personId", "assetId"], name: "IDX_bf339a24070dac7e71304ec530"
  end

  create_table "asset_files", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "assetId", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.string "type", null: false
    t.string "path", null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["assetId"], name: "IDX_asset_files_assetId"
    t.index ["updateId"], name: "IDX_asset_files_update_id"
    t.unique_constraint ["assetId", "type"], name: "UQ_assetId_type"
  end

  create_table "asset_job_status", primary_key: "assetId", id: :uuid, default: nil, force: :cascade do |t|
    t.timestamptz "facesRecognizedAt"
    t.timestamptz "metadataExtractedAt"
    t.timestamptz "duplicatesDetectedAt"
    t.timestamptz "previewAt"
    t.timestamptz "thumbnailAt"
  end

  create_table "asset_stack", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "primaryAssetId", null: false
    t.uuid "ownerId", null: false
    t.index ["ownerId"], name: "IDX_c05079e542fd74de3b5ecb5c1c"
    t.index ["primaryAssetId"], name: "IDX_91704e101438fd0653f582426d"
    t.unique_constraint ["primaryAssetId"], name: "REL_91704e101438fd0653f582426d"
  end

  create_table "assets", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "deviceAssetId", null: false
    t.uuid "ownerId", null: false
    t.string "deviceId", null: false
    t.string "type", null: false
    t.string "originalPath", null: false
    t.timestamptz "fileCreatedAt", null: false
    t.timestamptz "fileModifiedAt", null: false
    t.boolean "isFavorite", default: false, null: false
    t.string "duration"
    t.string "encodedVideoPath", default: ""
    t.binary "checksum", null: false
    t.uuid "livePhotoVideoId"
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.string "originalFileName", null: false
    t.string "sidecarPath"
    t.binary "thumbhash"
    t.boolean "isOffline", default: false, null: false
    t.uuid "libraryId"
    t.boolean "isExternal", default: false, null: false
    t.timestamptz "deletedAt"
    t.timestamptz "localDateTime", null: false
    t.uuid "stackId"
    t.uuid "duplicateId"
    t.enum "status", default: "active", null: false, enum_type: "assets_status_enum"
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.enum "visibility", default: "timeline", null: false, enum_type: "asset_visibility_enum"
    t.index "(((\"localDateTime\" AT TIME ZONE 'UTC'::text))::date)", name: "idx_local_date_time"
    t.index "(date_trunc('MONTH'::text, (\"localDateTime\" AT TIME ZONE 'UTC'::text)) AT TIME ZONE 'UTC'::text)", name: "idx_local_date_time_month"
    t.index "f_unaccent((\"originalFileName\")::text) gin_trgm_ops", name: "idx_originalfilename_trigram", using: :gin
    t.index ["checksum"], name: "IDX_8d3efe36c0755849395e6ea866"
    t.index ["duplicateId"], name: "IDX_assets_duplicateId"
    t.index ["fileCreatedAt"], name: "idx_asset_file_created_at"
    t.index ["id", "stackId"], name: "IDX_asset_id_stackId"
    t.index ["libraryId"], name: "IDX_9977c3c1de01c3d848039a6b90"
    t.index ["livePhotoVideoId"], name: "IDX_16294b83fa8c0149719a1f631e"
    t.index ["originalFileName"], name: "IDX_4d66e76dada1ca180f67a205dc"
    t.index ["originalPath", "libraryId"], name: "IDX_originalPath_libraryId"
    t.index ["ownerId", "checksum"], name: "UQ_assets_owner_checksum", unique: true, where: "(\"libraryId\" IS NULL)"
    t.index ["ownerId", "libraryId", "checksum"], name: "UQ_assets_owner_library_checksum", unique: true, where: "(\"libraryId\" IS NOT NULL)"
    t.index ["ownerId"], name: "IDX_2c5ac0d6fb58b238fd2068de67"
    t.index ["stackId"], name: "IDX_f15d48fa3ea5e4bda05ca8ab20"
    t.index ["updateId"], name: "IDX_assets_update_id"
  end

  create_table "assets_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "assetId", null: false
    t.uuid "ownerId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["assetId"], name: "IDX_assets_audit_asset_id"
    t.index ["deletedAt"], name: "IDX_assets_audit_deleted_at"
    t.index ["ownerId"], name: "IDX_assets_audit_owner_id"
  end

  create_table "audit", id: :serial, force: :cascade do |t|
    t.string "entityType", null: false
    t.uuid "entityId", null: false
    t.string "action", null: false
    t.uuid "ownerId", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.index ["ownerId", "createdAt"], name: "IDX_ownerId_createdAt"
  end

  create_table "exif", primary_key: "assetId", id: :uuid, default: nil, force: :cascade do |t|
    t.string "make"
    t.string "model"
    t.integer "exifImageWidth"
    t.integer "exifImageHeight"
    t.bigint "fileSizeInByte"
    t.string "orientation"
    t.timestamptz "dateTimeOriginal"
    t.timestamptz "modifyDate"
    t.string "lensModel"
    t.float "fNumber"
    t.float "focalLength"
    t.integer "iso"
    t.float "latitude"
    t.float "longitude"
    t.string "city"
    t.string "state"
    t.string "country"
    t.text "description", default: "", null: false
    t.float "fps"
    t.string "exposureTime"
    t.string "livePhotoCID"
    t.string "timeZone"
    t.string "projectionType"
    t.string "profileDescription"
    t.string "colorspace"
    t.integer "bitsPerSample"
    t.string "autoStackId"
    t.integer "rating"
    t.timestamptz "updatedAt", default: -> { "clock_timestamp()" }, null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["autoStackId"], name: "IDX_auto_stack_id"
    t.index ["city"], name: "exif_city"
    t.index ["livePhotoCID"], name: "IDX_live_photo_cid"
    t.index ["updateId"], name: "IDX_asset_exif_update_id"
  end

  create_table "face_search", primary_key: "faceId", id: :uuid, default: nil, force: :cascade do |t|
    t.vector "embedding", limit: 512, null: false
    t.index ["embedding"], name: "face_index", opclass: :vector_cosine_ops, using: :vchordrq
  end

  create_table "geodata_places", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 200, null: false
    t.float "longitude", null: false
    t.float "latitude", null: false
    t.string "countryCode", limit: 2, null: false
    t.string "admin1Code", limit: 20
    t.string "admin2Code", limit: 80
    t.date "modificationDate", null: false
    t.string "admin1Name"
    t.string "admin2Name"
    t.string "alternateNames"
    t.index "f_unaccent((\"admin1Name\")::text) gin_trgm_ops", name: "idx_geodata_places_admin1_name", using: :gin
    t.index "f_unaccent((\"admin2Name\")::text) gin_trgm_ops", name: "idx_geodata_places_admin2_name", using: :gin
    t.index "f_unaccent((\"alternateNames\")::text) gin_trgm_ops", name: "idx_geodata_places_alternate_names", using: :gin
    t.index "f_unaccent((name)::text) gin_trgm_ops", name: "idx_geodata_places_name", using: :gin
    t.index "ll_to_earth_public(latitude, longitude)) WITH (fillfactor='100'", name: "idx_geodata_gist_earthcoord", using: :gist
  end

  create_table "kysely_migrations", primary_key: "name", id: { type: :string, limit: 255 }, force: :cascade do |t|
    t.string "timestamp", limit: 255, null: false
  end

  create_table "kysely_migrations_lock", id: { type: :string, limit: 255 }, force: :cascade do |t|
    t.integer "is_locked", default: 0, null: false
  end

  create_table "libraries", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "ownerId", null: false
    t.text "importPaths", null: false, array: true
    t.text "exclusionPatterns", null: false, array: true
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.timestamptz "deletedAt"
    t.timestamptz "refreshedAt"
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["ownerId"], name: "IDX_0f6fc2fb195f24d19b0fb0d57c"
    t.index ["updateId"], name: "IDX_libraries_update_id"
  end

  create_table "memories", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.timestamptz "deletedAt"
    t.uuid "ownerId", null: false
    t.string "type", null: false
    t.jsonb "data", null: false
    t.boolean "isSaved", default: false, null: false
    t.timestamptz "memoryAt", null: false
    t.timestamptz "seenAt"
    t.timestamptz "showAt"
    t.timestamptz "hideAt"
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["ownerId"], name: "IDX_575842846f0c28fa5da46c99b1"
    t.index ["updateId"], name: "IDX_memories_update_id"
  end

  create_table "memories_assets_assets", primary_key: ["memoriesId", "assetsId"], force: :cascade do |t|
    t.uuid "memoriesId", null: false
    t.uuid "assetsId", null: false
    t.index ["assetsId"], name: "IDX_6942ecf52d75d4273de19d2c16"
    t.index ["memoriesId"], name: "IDX_984e5c9ab1f04d34538cd32334"
  end

  create_table "move_history", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "entityId", null: false
    t.string "pathType", null: false
    t.string "oldPath", null: false
    t.string "newPath", null: false

    t.unique_constraint ["entityId", "pathType"], name: "UQ_entityId_pathType"
    t.unique_constraint ["newPath"], name: "UQ_newPath"
  end

  create_table "naturalearth_countries", id: :integer, default: nil, force: :cascade do |t|
    t.string "admin", limit: 50, null: false
    t.string "admin_a3", limit: 3, null: false
    t.string "type", limit: 50, null: false
    t.polygon "coordinates", null: false
  end

  create_table "notifications", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.timestamptz "deletedAt"
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.uuid "userId"
    t.string "level", default: "info", null: false
    t.string "type", default: "info", null: false
    t.jsonb "data"
    t.string "title", null: false
    t.text "description"
    t.timestamptz "readAt"
    t.index ["updateId"], name: "IDX_notifications_update_id"
    t.index ["userId"], name: "IDX_692a909ee0fa9383e7859f9b40"
  end

  create_table "partners", primary_key: ["sharedById", "sharedWithId"], force: :cascade do |t|
    t.uuid "sharedById", null: false
    t.uuid "sharedWithId", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.boolean "inTimeline", default: false, null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["sharedWithId"], name: "IDX_d7e875c6c60e661723dbf372fd"
    t.index ["updateId"], name: "IDX_partners_update_id"
  end

  create_table "partners_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "sharedById", null: false
    t.uuid "sharedWithId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["deletedAt"], name: "IDX_partners_audit_deleted_at"
    t.index ["sharedById"], name: "IDX_partners_audit_shared_by_id"
    t.index ["sharedWithId"], name: "IDX_partners_audit_shared_with_id"
  end

  create_table "person", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.uuid "ownerId", null: false
    t.string "name", default: "", null: false
    t.string "thumbnailPath", default: "", null: false
    t.boolean "isHidden", default: false, null: false
    t.date "birthDate"
    t.uuid "faceAssetId"
    t.boolean "isFavorite", default: false, null: false
    t.string "color"
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["faceAssetId"], name: "IDX_2bbabe31656b6778c6b87b6102"
    t.index ["ownerId"], name: "IDX_5527cc99f530a547093f9e577b"
    t.index ["updateId"], name: "IDX_person_update_id"
    t.check_constraint "\"birthDate\" <= CURRENT_DATE", name: "CHK_b0f82b0ed662bfc24fbb58bb45"
  end

  create_table "session_sync_checkpoints", primary_key: ["sessionId", "type"], force: :cascade do |t|
    t.uuid "sessionId", null: false
    t.string "type", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.string "ack", null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["sessionId"], name: "IDX_d8ddd9d687816cc490432b3d4b"
    t.index ["updateId"], name: "IDX_session_sync_checkpoints_update_id"
  end

  create_table "sessions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "token", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.uuid "userId", null: false
    t.string "deviceType", default: "", null: false
    t.string "deviceOS", default: "", null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.timestamptz "pinExpiresAt"
    t.timestamptz "expiresAt"
    t.uuid "parentId"
    t.index ["parentId"], name: "IDX_afbbabbd7daf5b91de4dca84de"
    t.index ["updateId"], name: "IDX_sessions_update_id"
    t.index ["userId"], name: "IDX_57de40bc620f456c7311aa3a1e"
  end

  create_table "shared_link__asset", primary_key: ["assetsId", "sharedLinksId"], force: :cascade do |t|
    t.uuid "assetsId", null: false
    t.uuid "sharedLinksId", null: false
    t.index ["assetsId"], name: "IDX_5b7decce6c8d3db9593d6111a6"
    t.index ["sharedLinksId"], name: "IDX_c9fab4aa97ffd1b034f3d6581a"
  end

  create_table "shared_links", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "description"
    t.uuid "userId", null: false
    t.binary "key", null: false
    t.string "type", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "expiresAt"
    t.boolean "allowUpload", default: false, null: false
    t.uuid "albumId"
    t.boolean "allowDownload", default: true, null: false
    t.boolean "showExif", default: true, null: false
    t.string "password"
    t.index ["albumId"], name: "IDX_sharedlink_albumId"
    t.index ["key"], name: "IDX_sharedlink_key"
    t.index ["userId"], name: "IDX_66fe3837414c5a9f1c33ca4934"
    t.unique_constraint ["key"], name: "UQ_sharedlink_key"
  end

  create_table "smart_search", primary_key: "assetId", id: :uuid, default: nil, force: :cascade do |t|
    t.vector "embedding", limit: 512, null: false
    t.index ["embedding"], name: "clip_index", opclass: :vector_cosine_ops, using: :vchordrq
  end

  create_table "system_metadata", primary_key: "key", id: :string, force: :cascade do |t|
    t.jsonb "value", null: false
  end

  create_table "tag_asset", primary_key: ["assetsId", "tagsId"], force: :cascade do |t|
    t.uuid "assetsId", null: false
    t.uuid "tagsId", null: false
    t.index ["assetsId", "tagsId"], name: "IDX_tag_asset_assetsId_tagsId"
    t.index ["assetsId"], name: "IDX_f8e8a9e893cb5c54907f1b798e"
    t.index ["tagsId"], name: "IDX_e99f31ea4cdf3a2c35c7287eb4"
  end

  create_table "tags", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "userId", null: false
    t.string "value", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.string "color"
    t.uuid "parentId"
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["parentId"], name: "IDX_9f9590cc11561f1f48ff034ef9"
    t.index ["updateId"], name: "IDX_tags_update_id"
    t.unique_constraint ["userId", "value"], name: "UQ_79d6f16e52bb2c7130375246793"
  end

  create_table "tags_closure", primary_key: ["id_ancestor", "id_descendant"], force: :cascade do |t|
    t.uuid "id_ancestor", null: false
    t.uuid "id_descendant", null: false
    t.index ["id_ancestor"], name: "IDX_15fbcbc67663c6bfc07b354c22"
    t.index ["id_descendant"], name: "IDX_b1a2a7ed45c29179b5ad51548a"
  end

  create_table "user_metadata", primary_key: ["userId", "key"], force: :cascade do |t|
    t.uuid "userId", null: false
    t.string "key", null: false
    t.jsonb "value", null: false
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password", default: "", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.string "profileImagePath", default: "", null: false
    t.boolean "isAdmin", default: false, null: false
    t.boolean "shouldChangePassword", default: true, null: false
    t.timestamptz "deletedAt"
    t.string "oauthId", default: "", null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.string "storageLabel"
    t.string "name", default: "", null: false
    t.bigint "quotaSizeInBytes"
    t.bigint "quotaUsageInBytes", default: 0, null: false
    t.string "status", default: "active", null: false
    t.timestamptz "profileChangedAt", default: -> { "now()" }, null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.string "avatarColor"
    t.string "pinCode"
    t.index ["updateId"], name: "IDX_users_update_id"
    t.index ["updatedAt", "id"], name: "IDX_users_updated_at_asc_id_asc"
    t.unique_constraint ["email"], name: "UQ_97672ac88f789774dd47f7c8be3"
    t.unique_constraint ["storageLabel"], name: "UQ_b309cf34fa58137c416b32cea3a"
  end

  create_table "users_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "userId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["deletedAt"], name: "IDX_users_audit_deleted_at"
  end

  create_table "version_history", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.string "version", null: false
  end

  add_foreign_key "activity", "albums", column: "albumId", name: "FK_1af8519996fbfb3684b58df280b", on_update: :cascade, on_delete: :cascade
  add_foreign_key "activity", "assets", column: "assetId", name: "FK_8091ea76b12338cb4428d33d782", on_update: :cascade, on_delete: :cascade
  add_foreign_key "activity", "users", column: "userId", name: "FK_3571467bcbe021f66e2bdce96ea", on_update: :cascade, on_delete: :cascade
  add_foreign_key "albums", "assets", column: "albumThumbnailAssetId", name: "FK_05895aa505a670300d4816debce", on_update: :cascade, on_delete: :nullify
  add_foreign_key "albums", "users", column: "ownerId", name: "FK_b22c53f35ef20c28c21637c85f4", on_update: :cascade, on_delete: :cascade
  add_foreign_key "albums_assets_assets", "albums", column: "albumsId", name: "FK_e590fa396c6898fcd4a50e40927", on_update: :cascade, on_delete: :cascade
  add_foreign_key "albums_assets_assets", "assets", column: "assetsId", name: "FK_4bd1303d199f4e72ccdf998c621", on_update: :cascade, on_delete: :cascade
  add_foreign_key "albums_shared_users_users", "albums", column: "albumsId", name: "FK_427c350ad49bd3935a50baab737", on_update: :cascade, on_delete: :cascade
  add_foreign_key "albums_shared_users_users", "users", column: "usersId", name: "FK_f48513bf9bccefd6ff3ad30bd06", on_update: :cascade, on_delete: :cascade
  add_foreign_key "api_keys", "users", column: "userId", name: "FK_6c2e267ae764a9413b863a29342", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asset_faces", "assets", column: "assetId", name: "FK_02a43fd0b3c50fb6d7f0cb7282c", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asset_faces", "person", column: "personId", name: "FK_95ad7106dd7b484275443f580f9", on_update: :cascade, on_delete: :nullify
  add_foreign_key "asset_files", "assets", column: "assetId", name: "FK_e3e103a5f1d8bc8402999286040", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asset_job_status", "assets", column: "assetId", name: "FK_420bec36fc02813bddf5c8b73d4", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asset_stack", "assets", column: "primaryAssetId", name: "FK_91704e101438fd0653f582426dc"
  add_foreign_key "asset_stack", "users", column: "ownerId", name: "FK_c05079e542fd74de3b5ecb5c1c8", on_update: :cascade, on_delete: :cascade
  add_foreign_key "assets", "asset_stack", column: "stackId", name: "FK_f15d48fa3ea5e4bda05ca8ab207", on_update: :cascade, on_delete: :nullify
  add_foreign_key "assets", "assets", column: "livePhotoVideoId", name: "FK_16294b83fa8c0149719a1f631ef", on_update: :cascade, on_delete: :nullify
  add_foreign_key "assets", "libraries", column: "libraryId", name: "FK_9977c3c1de01c3d848039a6b90c", on_update: :cascade, on_delete: :cascade
  add_foreign_key "assets", "users", column: "ownerId", name: "FK_2c5ac0d6fb58b238fd2068de67d", on_update: :cascade, on_delete: :cascade
  add_foreign_key "exif", "assets", column: "assetId", name: "FK_c0117fdbc50b917ef9067740c44", on_delete: :cascade
  add_foreign_key "face_search", "asset_faces", column: "faceId", name: "face_search_faceId_fkey", on_delete: :cascade
  add_foreign_key "libraries", "users", column: "ownerId", name: "FK_0f6fc2fb195f24d19b0fb0d57c1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "memories", "users", column: "ownerId", name: "FK_575842846f0c28fa5da46c99b19", on_update: :cascade, on_delete: :cascade
  add_foreign_key "memories_assets_assets", "assets", column: "assetsId", name: "FK_6942ecf52d75d4273de19d2c16f", on_update: :cascade, on_delete: :cascade
  add_foreign_key "memories_assets_assets", "memories", column: "memoriesId", name: "FK_984e5c9ab1f04d34538cd32334e", on_update: :cascade, on_delete: :cascade
  add_foreign_key "notifications", "users", column: "userId", name: "FK_692a909ee0fa9383e7859f9b406", on_update: :cascade, on_delete: :cascade
  add_foreign_key "partners", "users", column: "sharedById", name: "FK_7e077a8b70b3530138610ff5e04", on_delete: :cascade
  add_foreign_key "partners", "users", column: "sharedWithId", name: "FK_d7e875c6c60e661723dbf372fd3", on_delete: :cascade
  add_foreign_key "person", "asset_faces", column: "faceAssetId", name: "FK_2bbabe31656b6778c6b87b61023", on_delete: :nullify
  add_foreign_key "person", "users", column: "ownerId", name: "FK_5527cc99f530a547093f9e577b6", on_update: :cascade, on_delete: :cascade
  add_foreign_key "session_sync_checkpoints", "sessions", column: "sessionId", name: "FK_d8ddd9d687816cc490432b3d4bc", on_update: :cascade, on_delete: :cascade
  add_foreign_key "sessions", "sessions", column: "parentId", name: "FK_afbbabbd7daf5b91de4dca84de8", on_update: :cascade, on_delete: :cascade
  add_foreign_key "sessions", "users", column: "userId", name: "FK_57de40bc620f456c7311aa3a1e6", on_update: :cascade, on_delete: :cascade
  add_foreign_key "shared_link__asset", "assets", column: "assetsId", name: "FK_5b7decce6c8d3db9593d6111a66", on_update: :cascade, on_delete: :cascade
  add_foreign_key "shared_link__asset", "shared_links", column: "sharedLinksId", name: "FK_c9fab4aa97ffd1b034f3d6581ab", on_update: :cascade, on_delete: :cascade
  add_foreign_key "shared_links", "albums", column: "albumId", name: "FK_0c6ce9058c29f07cdf7014eac66", on_update: :cascade, on_delete: :cascade
  add_foreign_key "shared_links", "users", column: "userId", name: "FK_66fe3837414c5a9f1c33ca49340", on_update: :cascade, on_delete: :cascade
  add_foreign_key "smart_search", "assets", column: "assetId", name: "smart_search_assetId_fkey", on_delete: :cascade
  add_foreign_key "tag_asset", "assets", column: "assetsId", name: "FK_f8e8a9e893cb5c54907f1b798e9", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tag_asset", "tags", column: "tagsId", name: "FK_e99f31ea4cdf3a2c35c7287eb42", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tags", "tags", column: "parentId", name: "FK_9f9590cc11561f1f48ff034ef99", on_delete: :cascade
  add_foreign_key "tags", "users", column: "userId", name: "FK_92e67dc508c705dd66c94615576", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tags_closure", "tags", column: "id_ancestor", name: "FK_15fbcbc67663c6bfc07b354c22c", on_delete: :cascade
  add_foreign_key "tags_closure", "tags", column: "id_descendant", name: "FK_b1a2a7ed45c29179b5ad51548a1", on_delete: :cascade
  add_foreign_key "user_metadata", "users", column: "userId", name: "FK_6afb43681a21cf7815932bc38ac", on_update: :cascade, on_delete: :cascade
end
