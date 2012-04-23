module Ejans
  module Noticable
    def unread_notices
      notices.where(read: false)
    end

    def unread_notices_count
      unread_notices.count
    end
  end
end