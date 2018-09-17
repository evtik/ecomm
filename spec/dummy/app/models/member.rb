class Member < ApplicationRecord
  has_many :addresses, class_name: 'Ecomm::Address',
                       foreign_key: :customer_id, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
