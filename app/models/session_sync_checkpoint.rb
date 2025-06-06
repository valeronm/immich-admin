class SessionSyncCheckpoint < ApplicationRecord
  belongs_to :session, foreign_key: :sessionId
end
