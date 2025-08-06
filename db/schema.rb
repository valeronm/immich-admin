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
    t.index ["albumId", "assetId"], name: "activity_albumId_assetId_idx"
    t.index ["albumId"], name: "activity_albumId_idx"
    t.index ["assetId", "userId", "albumId"], name: "activity_like_idx", unique: true, where: "(\"isLiked\" = true)"
    t.index ["assetId"], name: "activity_assetId_idx"
    t.index ["updateId"], name: "activity_updateId_idx"
    t.index ["userId"], name: "activity_userId_idx"
    t.check_constraint "comment IS NULL AND \"isLiked\" = true OR comment IS NOT NULL AND \"isLiked\" = false", name: "activity_like_check"
  end

  create_table "album", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.index ["albumThumbnailAssetId"], name: "album_albumThumbnailAssetId_idx"
    t.index ["ownerId"], name: "album_ownerId_idx"
    t.index ["updateId"], name: "album_updateId_idx"
  end

  create_table "album_asset", primary_key: ["albumsId", "assetsId"], force: :cascade do |t|
    t.uuid "albumsId", null: false
    t.uuid "assetsId", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["albumsId"], name: "album_asset_albumsId_idx"
    t.index ["assetsId"], name: "album_asset_assetsId_idx"
    t.index ["updateId"], name: "album_asset_updateId_idx"
  end

  create_table "album_asset_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "albumId", null: false
    t.uuid "assetId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["albumId"], name: "album_asset_audit_albumId_idx"
    t.index ["assetId"], name: "album_asset_audit_assetId_idx"
    t.index ["deletedAt"], name: "album_asset_audit_deletedAt_idx"
  end

  create_table "album_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "albumId", null: false
    t.uuid "userId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["albumId"], name: "album_audit_albumId_idx"
    t.index ["deletedAt"], name: "album_audit_deletedAt_idx"
    t.index ["userId"], name: "album_audit_userId_idx"
  end

  create_table "album_user", primary_key: ["albumsId", "usersId"], force: :cascade do |t|
    t.uuid "albumsId", null: false
    t.uuid "usersId", null: false
    t.string "role", default: "editor", null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.uuid "createId", default: -> { "immich_uuid_v7()" }, null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.index ["albumsId"], name: "album_user_albumsId_idx"
    t.index ["createId"], name: "album_user_createId_idx"
    t.index ["updateId"], name: "album_user_updateId_idx"
    t.index ["usersId"], name: "album_user_usersId_idx"
  end

  create_table "album_user_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "albumId", null: false
    t.uuid "userId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["albumId"], name: "album_user_audit_albumId_idx"
    t.index ["deletedAt"], name: "album_user_audit_deletedAt_idx"
    t.index ["userId"], name: "album_user_audit_userId_idx"
  end

  create_table "api_key", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "key", null: false
    t.uuid "userId", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.string "permissions", null: false, array: true
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["updateId"], name: "api_key_updateId_idx"
    t.index ["userId"], name: "api_key_userId_idx"
  end

  create_table "asset", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.index "(((\"localDateTime\" AT TIME ZONE 'UTC'::text))::date)", name: "asset_localDateTime_idx"
    t.index "(date_trunc('MONTH'::text, (\"localDateTime\" AT TIME ZONE 'UTC'::text)) AT TIME ZONE 'UTC'::text)", name: "asset_localDateTime_month_idx"
    t.index "f_unaccent((\"originalFileName\")::text) gin_trgm_ops", name: "asset_originalFilename_trigram_idx", using: :gin
    t.index ["checksum"], name: "asset_checksum_idx"
    t.index ["duplicateId"], name: "asset_duplicateId_idx"
    t.index ["fileCreatedAt"], name: "asset_fileCreatedAt_idx"
    t.index ["id", "stackId"], name: "asset_id_stackId_idx"
    t.index ["libraryId"], name: "asset_libraryId_idx"
    t.index ["livePhotoVideoId"], name: "asset_livePhotoVideoId_idx"
    t.index ["originalFileName"], name: "asset_originalFileName_idx"
    t.index ["originalPath", "libraryId"], name: "asset_originalPath_libraryId_idx"
    t.index ["ownerId", "checksum"], name: "UQ_assets_owner_checksum", unique: true, where: "(\"libraryId\" IS NULL)"
    t.index ["ownerId", "libraryId", "checksum"], name: "asset_ownerId_libraryId_checksum_idx", unique: true, where: "(\"libraryId\" IS NOT NULL)"
    t.index ["ownerId"], name: "asset_ownerId_idx"
    t.index ["stackId"], name: "asset_stackId_idx"
    t.index ["updateId"], name: "asset_updateId_idx"
  end

  create_table "asset_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "assetId", null: false
    t.uuid "ownerId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["assetId"], name: "asset_audit_assetId_idx"
    t.index ["deletedAt"], name: "asset_audit_deletedAt_idx"
    t.index ["ownerId"], name: "asset_audit_ownerId_idx"
  end

  create_table "asset_exif", primary_key: "assetId", id: :uuid, default: nil, force: :cascade do |t|
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
    t.index ["autoStackId"], name: "asset_exif_autoStackId_idx"
    t.index ["city"], name: "asset_exif_city_idx"
    t.index ["livePhotoCID"], name: "asset_exif_livePhotoCID_idx"
    t.index ["updateId"], name: "asset_exif_updateId_idx"
  end

  create_table "asset_face", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["assetId", "personId"], name: "asset_face_assetId_personId_idx"
    t.index ["personId", "assetId"], name: "asset_face_personId_assetId_idx"
  end

  create_table "asset_face_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "assetFaceId", null: false
    t.uuid "assetId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["assetFaceId"], name: "asset_face_audit_assetFaceId_idx"
    t.index ["assetId"], name: "asset_face_audit_assetId_idx"
    t.index ["deletedAt"], name: "asset_face_audit_deletedAt_idx"
  end

  create_table "asset_file", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "assetId", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.string "type", null: false
    t.string "path", null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["assetId"], name: "asset_file_assetId_idx"
    t.index ["updateId"], name: "asset_file_updateId_idx"
    t.unique_constraint ["assetId", "type"], name: "asset_file_assetId_type_uq"
  end

  create_table "asset_job_status", primary_key: "assetId", id: :uuid, default: nil, force: :cascade do |t|
    t.timestamptz "facesRecognizedAt"
    t.timestamptz "metadataExtractedAt"
    t.timestamptz "duplicatesDetectedAt"
    t.timestamptz "previewAt"
    t.timestamptz "thumbnailAt"
  end

  create_table "audit", id: :serial, force: :cascade do |t|
    t.string "entityType", null: false
    t.uuid "entityId", null: false
    t.string "action", null: false
    t.uuid "ownerId", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.index ["ownerId", "createdAt"], name: "audit_ownerId_createdAt_idx"
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
    t.index "ll_to_earth_public(latitude, longitude)", name: "IDX_geodata_gist_earthcoord", using: :gist
  end

  create_table "kysely_migrations", primary_key: "name", id: { type: :string, limit: 255 }, force: :cascade do |t|
    t.string "timestamp", limit: 255, null: false
  end

  create_table "kysely_migrations_lock", id: { type: :string, limit: 255 }, force: :cascade do |t|
    t.integer "is_locked", default: 0, null: false
  end

  create_table "library", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "ownerId", null: false
    t.text "importPaths", null: false, array: true
    t.text "exclusionPatterns", null: false, array: true
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.timestamptz "deletedAt"
    t.timestamptz "refreshedAt"
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["ownerId"], name: "library_ownerId_idx"
    t.index ["updateId"], name: "library_updateId_idx"
  end

  create_table "memory", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.index ["ownerId"], name: "memory_ownerId_idx"
    t.index ["updateId"], name: "memory_updateId_idx"
  end

  create_table "memory_asset", primary_key: ["memoriesId", "assetsId"], force: :cascade do |t|
    t.uuid "memoriesId", null: false
    t.uuid "assetsId", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["assetsId"], name: "memory_asset_assetsId_idx"
    t.index ["memoriesId"], name: "memory_asset_memoriesId_idx"
    t.index ["updateId"], name: "memory_asset_updateId_idx"
  end

  create_table "memory_asset_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "memoryId", null: false
    t.uuid "assetId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["assetId"], name: "memory_asset_audit_assetId_idx"
    t.index ["deletedAt"], name: "memory_asset_audit_deletedAt_idx"
    t.index ["memoryId"], name: "memory_asset_audit_memoryId_idx"
  end

  create_table "memory_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "memoryId", null: false
    t.uuid "userId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["deletedAt"], name: "memory_audit_deletedAt_idx"
    t.index ["memoryId"], name: "memory_audit_memoryId_idx"
    t.index ["userId"], name: "memory_audit_userId_idx"
  end

  create_table "migration_overrides", primary_key: "name", id: :string, force: :cascade do |t|
    t.jsonb "value", null: false
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

  create_table "notification", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.index ["updateId"], name: "notification_updateId_idx"
    t.index ["userId"], name: "notification_userId_idx"
  end

  create_table "partner", primary_key: ["sharedById", "sharedWithId"], force: :cascade do |t|
    t.uuid "sharedById", null: false
    t.uuid "sharedWithId", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.boolean "inTimeline", default: false, null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.uuid "createId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["createId"], name: "partner_createId_idx"
    t.index ["sharedWithId"], name: "partner_sharedWithId_idx"
    t.index ["updateId"], name: "partner_updateId_idx"
  end

  create_table "partner_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "sharedById", null: false
    t.uuid "sharedWithId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["deletedAt"], name: "partner_audit_deletedAt_idx"
    t.index ["sharedById"], name: "partner_audit_sharedById_idx"
    t.index ["sharedWithId"], name: "partner_audit_sharedWithId_idx"
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
    t.index ["faceAssetId"], name: "person_faceAssetId_idx"
    t.index ["ownerId"], name: "person_ownerId_idx"
    t.index ["updateId"], name: "person_updateId_idx"
    t.check_constraint "\"birthDate\" <= CURRENT_DATE", name: "person_birthDate_chk"
  end

  create_table "person_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "personId", null: false
    t.uuid "ownerId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["deletedAt"], name: "person_audit_deletedAt_idx"
    t.index ["ownerId"], name: "person_audit_ownerId_idx"
    t.index ["personId"], name: "person_audit_personId_idx"
  end

  create_table "session", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.boolean "isPendingSyncReset", default: false, null: false
    t.index ["parentId"], name: "session_parentId_idx"
    t.index ["updateId"], name: "session_updateId_idx"
    t.index ["userId"], name: "session_userId_idx"
  end

  create_table "session_sync_checkpoint", primary_key: ["sessionId", "type"], force: :cascade do |t|
    t.uuid "sessionId", null: false
    t.string "type", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.string "ack", null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["sessionId"], name: "session_sync_checkpoint_sessionId_idx"
    t.index ["updateId"], name: "session_sync_checkpoint_updateId_idx"
  end

  create_table "shared_link", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.string "slug"
    t.index ["albumId"], name: "shared_link_albumId_idx"
    t.index ["key"], name: "shared_link_key_idx"
    t.index ["userId"], name: "shared_link_userId_idx"
    t.unique_constraint ["key"], name: "shared_link_key_uq"
    t.unique_constraint ["slug"], name: "shared_link_slug_uq"
  end

  create_table "shared_link_asset", primary_key: ["assetsId", "sharedLinksId"], force: :cascade do |t|
    t.uuid "assetsId", null: false
    t.uuid "sharedLinksId", null: false
    t.index ["assetsId"], name: "shared_link_asset_assetsId_idx"
    t.index ["sharedLinksId"], name: "shared_link_asset_sharedLinksId_idx"
  end

  create_table "smart_search", primary_key: "assetId", id: :uuid, default: nil, force: :cascade do |t|
    t.vector "embedding", limit: 512, null: false
    t.index ["embedding"], name: "clip_index", opclass: :vector_cosine_ops, using: :vchordrq
  end

  create_table "stack", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "primaryAssetId", null: false
    t.uuid "ownerId", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["ownerId"], name: "stack_ownerId_idx"
    t.index ["primaryAssetId"], name: "stack_primaryAssetId_idx"
    t.unique_constraint ["primaryAssetId"], name: "stack_primaryAssetId_uq"
  end

  create_table "stack_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "stackId", null: false
    t.uuid "userId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["deletedAt"], name: "stack_audit_deletedAt_idx"
  end

  create_table "system_metadata", primary_key: "key", id: :string, force: :cascade do |t|
    t.jsonb "value", null: false
  end

  create_table "tag", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "userId", null: false
    t.string "value", null: false
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.string "color"
    t.uuid "parentId"
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.index ["parentId"], name: "tag_parentId_idx"
    t.index ["updateId"], name: "tag_updateId_idx"
    t.unique_constraint ["userId", "value"], name: "tag_userId_value_uq"
  end

  create_table "tag_asset", primary_key: ["assetsId", "tagsId"], force: :cascade do |t|
    t.uuid "assetsId", null: false
    t.uuid "tagsId", null: false
    t.index ["assetsId", "tagsId"], name: "tag_asset_assetsId_tagsId_idx"
    t.index ["assetsId"], name: "tag_asset_assetsId_idx"
    t.index ["tagsId"], name: "tag_asset_tagsId_idx"
  end

  create_table "tag_closure", primary_key: ["id_ancestor", "id_descendant"], force: :cascade do |t|
    t.uuid "id_ancestor", null: false
    t.uuid "id_descendant", null: false
    t.index ["id_ancestor"], name: "tag_closure_id_ancestor_idx"
    t.index ["id_descendant"], name: "tag_closure_id_descendant_idx"
  end

  create_table "user", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
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
    t.index ["updateId"], name: "user_updateId_idx"
    t.index ["updatedAt", "id"], name: "user_updatedAt_id_idx"
    t.unique_constraint ["email"], name: "user_email_uq"
    t.unique_constraint ["storageLabel"], name: "user_storageLabel_uq"
  end

  create_table "user_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "userId", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["deletedAt"], name: "user_audit_deletedAt_idx"
  end

  create_table "user_metadata", primary_key: ["userId", "key"], force: :cascade do |t|
    t.uuid "userId", null: false
    t.string "key", null: false
    t.jsonb "value", null: false
    t.uuid "updateId", default: -> { "immich_uuid_v7()" }, null: false
    t.timestamptz "updatedAt", default: -> { "now()" }, null: false
    t.index ["updateId"], name: "IDX_user_metadata_update_id"
    t.index ["updatedAt"], name: "IDX_user_metadata_updated_at"
  end

  create_table "user_metadata_audit", id: :uuid, default: -> { "immich_uuid_v7()" }, force: :cascade do |t|
    t.uuid "userId", null: false
    t.string "key", null: false
    t.timestamptz "deletedAt", default: -> { "clock_timestamp()" }, null: false
    t.index ["deletedAt"], name: "IDX_user_metadata_audit_deleted_at"
    t.index ["key"], name: "IDX_user_metadata_audit_key"
    t.index ["userId"], name: "IDX_user_metadata_audit_user_id"
  end

  create_table "version_history", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.timestamptz "createdAt", default: -> { "now()" }, null: false
    t.string "version", null: false
  end

  add_foreign_key "activity", "album", column: "albumId", name: "activity_albumId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "activity", "album_asset", column: ["albumId", "assetId"], primary_key: ["albumsId", "assetsId"], name: "activity_albumId_assetId_fkey", on_delete: :cascade
  add_foreign_key "activity", "asset", column: "assetId", name: "activity_assetId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "activity", "user", column: "userId", name: "activity_userId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "album", "asset", column: "albumThumbnailAssetId", name: "album_albumThumbnailAssetId_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "album", "user", column: "ownerId", name: "album_ownerId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "album_asset", "album", column: "albumsId", name: "album_asset_albumsId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "album_asset", "asset", column: "assetsId", name: "album_asset_assetsId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "album_asset_audit", "album", column: "albumId", name: "album_asset_audit_albumId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "album_user", "album", column: "albumsId", name: "album_user_albumsId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "album_user", "user", column: "usersId", name: "album_user_usersId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "api_key", "user", column: "userId", name: "api_key_userId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asset", "asset", column: "livePhotoVideoId", name: "asset_livePhotoVideoId_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "asset", "library", column: "libraryId", name: "asset_libraryId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asset", "stack", column: "stackId", name: "asset_stackId_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "asset", "user", column: "ownerId", name: "asset_ownerId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asset_exif", "asset", column: "assetId", name: "asset_exif_assetId_fkey", on_delete: :cascade
  add_foreign_key "asset_face", "asset", column: "assetId", name: "asset_face_assetId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asset_face", "person", column: "personId", name: "asset_face_personId_fkey", on_update: :cascade, on_delete: :nullify
  add_foreign_key "asset_file", "asset", column: "assetId", name: "asset_file_assetId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "asset_job_status", "asset", column: "assetId", name: "asset_job_status_assetId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "face_search", "asset_face", column: "faceId", name: "face_search_faceId_fkey", on_delete: :cascade
  add_foreign_key "library", "user", column: "ownerId", name: "library_ownerId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "memory", "user", column: "ownerId", name: "memory_ownerId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "memory_asset", "asset", column: "assetsId", name: "memory_asset_assetsId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "memory_asset", "memory", column: "memoriesId", name: "memory_asset_memoriesId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "memory_asset_audit", "memory", column: "memoryId", name: "memory_asset_audit_memoryId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "notification", "user", column: "userId", name: "notification_userId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "partner", "user", column: "sharedById", name: "partner_sharedById_fkey", on_delete: :cascade
  add_foreign_key "partner", "user", column: "sharedWithId", name: "partner_sharedWithId_fkey", on_delete: :cascade
  add_foreign_key "person", "asset_face", column: "faceAssetId", name: "person_faceAssetId_fkey", on_delete: :nullify
  add_foreign_key "person", "user", column: "ownerId", name: "person_ownerId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "session", "session", column: "parentId", name: "session_parentId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "session", "user", column: "userId", name: "session_userId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "session_sync_checkpoint", "session", column: "sessionId", name: "session_sync_checkpoint_sessionId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "shared_link", "album", column: "albumId", name: "shared_link_albumId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "shared_link", "user", column: "userId", name: "shared_link_userId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "shared_link_asset", "asset", column: "assetsId", name: "shared_link_asset_assetsId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "shared_link_asset", "shared_link", column: "sharedLinksId", name: "shared_link_asset_sharedLinksId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "smart_search", "asset", column: "assetId", name: "smart_search_assetId_fkey", on_delete: :cascade
  add_foreign_key "stack", "asset", column: "primaryAssetId", name: "stack_primaryAssetId_fkey"
  add_foreign_key "stack", "user", column: "ownerId", name: "stack_ownerId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tag", "tag", column: "parentId", name: "tag_parentId_fkey", on_delete: :cascade
  add_foreign_key "tag", "user", column: "userId", name: "tag_userId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tag_asset", "asset", column: "assetsId", name: "tag_asset_assetsId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tag_asset", "tag", column: "tagsId", name: "tag_asset_tagsId_fkey", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tag_closure", "tag", column: "id_ancestor", name: "tag_closure_id_ancestor_fkey", on_delete: :cascade
  add_foreign_key "tag_closure", "tag", column: "id_descendant", name: "tag_closure_id_descendant_fkey", on_delete: :cascade
  add_foreign_key "user_metadata", "user", column: "userId", name: "user_metadata_userId_fkey", on_update: :cascade, on_delete: :cascade
end
