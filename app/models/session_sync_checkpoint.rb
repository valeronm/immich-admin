class SessionSyncCheckpoint < ApplicationRecord
  self.table_name = "session_sync_checkpoint"
  self.inheritance_column = :_type_disabled

  belongs_to :session, foreign_key: :sessionId
end
