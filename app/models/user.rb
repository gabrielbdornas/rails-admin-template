class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :registerable, :recoverable, :rememberable, -- para não deixar usuário se cadastrar ou recuperar senha
  devise :database_authenticatable, :validatable
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password, :password_confirmation, presence: true

  rails_admin do
    show do
      field  :name
      field  :admin
      field  :email
    end
    list do
      field  :name
      field  :admin
      field  :email
    end
    edit do
      field  :name
      field  :email
      field  :admin
      field  :password
      field  :password_confirmation
    end
  end
end
