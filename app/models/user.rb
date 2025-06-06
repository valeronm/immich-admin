class User < ApplicationRecord
  enum :status, active: "active", removing: "removing", deleted: "deleted"

  has_many :albums, foreign_key: :ownerId
  has_many :assets, foreign_key: :ownerId
  has_many :asset_stacks, foreign_key: :ownerId
  has_many :libraries, foreign_key: :ownerId
  has_many :memories, foreign_key: :ownerId
  has_many :people, foreign_key: :ownerId

  has_many :api_keys, foreign_key: :userId
  has_many :notifications, foreign_key: :userId
  has_many :tags, foreign_key: :userId
  has_many :sessions, foreign_key: :userId
  has_many :shared_links, foreign_key: :userId

  has_many :metadata, class_name: "UserMetadata", foreign_key: :userId

  has_many :partners_to, class_name: "Partner", foreign_key: :sharedById
  has_many :sharing_with, through: :partners_to, source: :shared_with

  has_many :partners_from, class_name: "Partner", foreign_key: :sharedWithId
  has_many :sharing_from, through: :partners_from, source: :shared_by

  has_and_belongs_to_many :shared_albums,
                          class_name: "Album",
                          join_table: :albums_shared_users_users,
                          foreign_key: :usersId,
                          association_foreign_key: :albumsId

  UserMetadata::KEYS.each do |key|
    define_method(key) do
      metadata.find_by(key:)&.value
    end
  end
end
