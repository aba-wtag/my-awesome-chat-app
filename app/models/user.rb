class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :participants, dependent: :destroy
  has_many :conversations, through: :participants
  has_many :messages, dependent: :destroy

  validates :name, presence: true
end