class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  # If it's a group, roles can be 'admin' or 'member'. For 1-to-1, we can just use 'member' or leave it nil.
  validates :role, inclusion: { in: %w[admin member] }, allow_nil: true
end