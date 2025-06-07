module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      set_current_user || reject_unauthorized_connection
    end

    private
      def set_current_user
        user_id = cookies.signed[:user_id]
        user = User.find_by(id: user_id) if user_id

        if user
          self.current_user = user
        end
      end
  end
end
