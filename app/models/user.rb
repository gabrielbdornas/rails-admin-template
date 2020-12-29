class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :registerable, :recoverable, :rememberable, -- para não deixar usuário se cadastrar ou recuperar senha
  devise :database_authenticatable, :validatable
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password, :password_confirmation, presence: true
  has_many :crib_indices
  has_many :apache_indices

  rails_admin do
    show do
      field  :unidade_abreviacao
      field  :email
    end
    list do
      field  :unidade_abreviacao
      field  :email
    end
    edit do
      field  :email
      field  :password
      field  :password_confirmation
    end
  end
end
