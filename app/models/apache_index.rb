class ApacheIndex < ApplicationRecord
  belongs_to :user
  validates :period, presence: true, inclusion: ApplicationController.helpers.date_between
  validates :grau, presence: true
  # https://guides.rubyonrails.org/active_record_validations.html#uniqueness
  # https://stackoverflow.com/questions/41888549/how-to-implement-composite-primary-keys-in-rails
  validates :user_id, uniqueness: { scope: [:period, :grau],
      message: "Apenas um Grau por período" }
  # https://stackoverflow.com/questions/6881900/how-to-check-if-a-number-is-included-in-a-range-in-one-statement
  validates :predicao_obitos, presence: true, numericality: {only_integer: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :numero_saidas, presence: true, numericality: {only_integer: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :numero_obitos_ocorridos, presence: true, numericality: {only_integer: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :numero_obitos_esperados, presence: true, numericality: {only_integer: false, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}

  before_save do
    if self.grau == 'I'
      self.score_apache = '0 a 4'
    elsif self.grau == 'II'
      self.score_apache = '5 a 09'
    elsif self.grau == 'III'
      self.score_apache = '10 a 14'
    elsif self.grau == 'IV'
      self.score_apache = '15 a 19'
    elsif self.grau == 'V'
      self.score_apache = '20 a 24'
    elsif self.grau == 'VI'
      self.score_apache = '25 a 29'
    elsif self.grau == 'VII'
      self.score_apache = '30 a 34'
    else
      self.score_apache = '> 34'
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
      field  :score_apache
      field  :predicao_obitos
      field  :numero_saidas
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
      field  :score_apache
      field  :predicao_obitos
      field  :numero_saidas
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
          ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII']
        end
      end
      field  :predicao_obitos
      field  :numero_saidas
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
          ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII']
        end
      end
      field  :predicao_obitos
      field  :numero_saidas
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
