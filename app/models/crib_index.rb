class CribIndex < ApplicationRecord
  # https://makandracards.com/makandra/1307-how-to-use-helper-methods-inside-a-model
  belongs_to :user
  validates :period, presence: true, inclusion: ApplicationController.helpers.date_between
  validates :grau, presence: true
  # https://guides.rubyonrails.org/active_record_validations.html#uniqueness
  # https://stackoverflow.com/questions/41888549/how-to-implement-composite-primary-keys-in-rails
  validates :user_id, uniqueness: { scope: [:period, :grau],
      message: "Apenas um Grau por período" }
  # https://stackoverflow.com/questions/6881900/how-to-check-if-a-number-is-included-in-a-range-in-one-statement
  validates :predicao_obitos, presence: true, numericality: {only_integer: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :numero_saidas_rn, presence: true, numericality: {only_integer: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :numero_obitos_ocorridos, presence: true, numericality: {only_integer: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :numero_obitos_esperados, presence: true, numericality: {only_integer: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}

  before_save do
    if self.grau == 'I'
      self.score_crib = '0 a 5'
    elsif self.grau == 'II'
      self.score_crib = '6 a 10'
    elsif self.grau == 'III'
      self.score_crib = '11 a 15'
    else
      self.score_crib = '> 15'
    end
  end


  # https://github.com/sferik/rails_admin/wiki/Models
  rails_admin do
    weight -1
    list do
      field  :user_id do
        formatted_value do
          User.find(value).unidade_abreviacao
        end
      end
      field  :period
      field  :grau
      field  :score_crib
      field  :predicao_obitos
      field  :numero_saidas_rn
      field  :numero_obitos_ocorridos
      field  :numero_obitos_esperados
      field  :updated_at do
        strftime_format "%d/%m/%Y %H:%M"
      end
    end

    show do
      field  :user_id do
        formatted_value do
          User.find(value).unidade_abreviacao
        end
      end
      field  :period
      field  :grau
      field  :score_crib
      field  :predicao_obitos
      field  :numero_saidas_rn
      field  :numero_obitos_ocorridos
      field  :numero_obitos_esperados
      field  :updated_at do
        strftime_format "%d/%m/%Y %H:%M"
      end
    end

    create do
      field  :period, :enum do
        enum do
          ApplicationController.helpers.date_between
        end
      end
      field :grau, :enum do
        enum do
          ['I', 'II', 'III', 'IV']
        end
      end
      field  :predicao_obitos
      field  :numero_saidas_rn
      field  :numero_obitos_ocorridos
      field  :numero_obitos_esperados

      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end
    end

    edit do
      field  :period, :enum do
        enum do
          ApplicationController.helpers.date_between
        end
      end
      field :grau, :enum do
        enum do
          ['I', 'II', 'III', 'IV']
        end
      end
      field  :predicao_obitos
      field  :numero_saidas_rn
      field  :numero_obitos_ocorridos
      field  :numero_obitos_esperados

      field :user_id, :hidden do
        default_value do
          bindings[:view]._current_user.id
        end
      end
    end
  end
end
