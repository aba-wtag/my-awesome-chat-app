class Conversation < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  has_many :messages, dependent: :destroy

  validates :unique_key, uniqueness: true, allow_nil: true

  # --- The 1-to-1 Logic ---
  def self.find_or_create_direct_chat(user1, user2)
    users = [user1, user2].sort_by(&:id)
    
    key = "#{users[0].id}_#{users[1].id}"

    existing_chat = find_by(is_group: false, unique_key: key)
    return existing_chat if existing_chat

    transaction do
      chat = create!(is_group: false, unique_key: key)
      chat.participants.create!([
        { user: users[0], role: 'member' },
        { user: users[1], role: 'member' }
      ])
      chat
    end
  end
end