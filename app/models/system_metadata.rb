class SystemMetadata < ApplicationRecord
  self.table_name = "system_metadata"

  KEYS = [
    SYSTEM_FLAGS = "system-flags".freeze,
    ADMIN_ONBOARDING = "admin-onboarding".freeze,
    REVERSE_GEOCODING_STATE = "reverse-geocoding-state".freeze,
    FACIAL_RECOGNITION_STATE = "facial-recognition-state".freeze,
    MEMORIES_STATE = "memories-state".freeze,
    VERSION_CHECK_STATE = "version-check-state".freeze,
    SYSTEM_CONFIG = "system-config".freeze,
    LICENSE = "license"
  ].freeze

  KEYS.each do |key|
    define_singleton_method(key.underscore.to_sym) do
      find_by(key:)&.value
    end
  end
end
