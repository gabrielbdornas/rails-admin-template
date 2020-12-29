# Referências:

- Máquina Linux Ubunto 20.04 (Ruby instalado default)
- Instalação rails
```
# terminal

## verfica dependencias
$ ruby -v # verifica ruby geralmente pré-instaldo
$ rmv list rubies # verifica todas as versoes instaladas
$ node --version # testa node instalado
$ yarn --version # testa yarn instalado
$ gem list rails # VERIFICA versões rails disponíveis (gem install rails para versao mais recente e definida como padrao)

# Instalar node - https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04
$ sudo apt update
$ sudo apt install nodejs

# Instalar yarn -- https://classic.yarnpkg.com/en/docs/install/#debian-stable
$ curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
$ sudo apt update && sudo apt install yarn

## Instalar rails
$ gem install rails # CASO rails AINDA NAO ESTEJA INSTALDO

```

-YouTube
https://www.youtube.com/watch?v=0Y7B4h3Mwi8
https://www.youtube.com/watch?v=zeaNeuZC3tA&t=743s
https://www.youtube.com/watch?v=LrbB1sjF8Ts&t=877s
https://www.youtube.com/watch?v=fHoWq_jiWHs&t=1s
https://www.youtube.com/watch?v=MQbdH0aBiFo&t=18s

# Funcionalidades

[x] Criação painel admin para gerenciar lançamentos

```
# gemfile

gem 'rails_admin'
```

```
# terminal

bundle
rails g rails_admin:install
```

[x] Usuário poderá logar no sistema.
- Usuário não poderá criar login e senha ou se cadastrar. Somente usuário admin poderá gerenciar usuários cadastrados. Como primeira versão apenas usuário admin poderá gerenciar senhas caso unidades a percam.
- Cada unidades(hospital) terá um login único para lançamento de suas informações


* implementação:
- criação model user:

```
# termianl
rails g model nome:string user admin:boolean
```

- implementação devise gem

```
# Gemfile

gem 'devise'
```

```
# terminal

bundle
rails generate devise:install
rails generate devise User
```
- Validações casdro de usuário (email único e sem possibilidade de se registrar ou recuperar senha)

```
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :registerable, :recoverable -- para não deixar usuário se cadastrar ou recuperar senha
  devise :database_authenticatable, :rememberable, :validatable
  validates :email, presence: true
  validates :email, uniqueness: true

end
```


```
# /config/initializers/rails_admin.rb

## == Devise ==
config.authenticate_with do
  warden.authenticate! scope: :user
end
config.current_user_method(&:current_user)
```

- Criando seeds para os usuários

```
# /db/seeds.rb

User.create admin: true, email: 'gabrielbdornas@gmail.com', password: 123456, password_confirmation:123456

```

```
terminal

$ rails db:create db:migrate db:seed # utilizar db:drop caso já haja algum banco criado (não necessário se for a primeira vez)
```

- gem cancancan para permissões

```
# Gemfile

gem 'cancancan', '~> 1.15.0'
```

```
# terminal

$ bundle
$ rails g cancan:ability
```

```
# rails_admin initializer

# /config/initializers/rails_admin.rb

## == Cancan ==
config.authorize_with :cancan
```

- Cadastrando primeiras restrições

```
class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.admin == false
        # https://stackoverflow.com/questions/44497687/a-gem-cancan-access-denied-maincontroller-dashboard?answertab=votes#tab-top
        can :dashboard, :all
        can :access, :rails_admin
        can :read, :dashboard
        can :read, User, id: user.id
        can :update, User, id: user.id
        # can :manage, ModelName, user: user
      elsif user.admin == true
        can :manage, :all
      end
    end
  end
end
```

[x] Períodos

```
# aplication_helper

module ApplicationHelper

  def date_between
    # https://stackoverflow.com/questions/925905/is-it-possible-to-create-a-list-of-months-between-two-dates-in-rails
    initial_date = Date.parse("2020-08-01")
    final_date = Date.parse("#{Time.new.year}-#{Time.new.month}-#{Time.new.day}")
    date_between_range = []
    Date.months_between(initial_date,final_date).to_a.each do |date|
      date_between_range << "#{date.month}/#{date.year}"
    end
    date_between_range
  end
end
```

obs.: utilizar ApplicationController.helpers.date_between para chamar o array criado

- Habilitar tabela crib_index para cadastro

```
# rails_admin initializer

  config.model CribIndex do
    create do
      field  :period, :enum do
        help 'Por favor selecione o mes'
        enum do
          ApplicationController.helpers.date_between
        end
      end
      field  :grau
      field  :score_crib
      field  :predicao_obitos
    end
  end
```

[x] Usuário sempre será vinculado ao registro que ele está criando

-- Índice Crib vinculado ao usuário que está cadastrando, configurando todo CRUD da tabela no model (verificar todo model CribIndex)

[x] Usuário poderá acessar dados de sua conta e trocar senha

```
# user model

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :registerable, :recoverable, :rememberable, -- para não deixar usuário se cadastrar ou recuperar senha
  devise :database_authenticatable, :validatable
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :password, :password_confirmation, presence: true
  has_many :crib_indexes

  rails_admin do
    list do
      field  :unidade_abreviacao do
        label 'Unidade'
      end
      field  :email do
        label 'Email'
      end
    end
    edit do
      field  :email do
        label 'Email'
      end
      field  :password do
        label 'Senha'
      end
      field  :password_confirmation do
        label 'Confirmação Senha'
      end
    end
  end
end

```

[x] Tabela crib_indices com primary_key juntando os campos (usuario_id, period, grau, score_crib)

```
# Acrescentado no crib_index model
# https://stackoverflow.com/questions/41888549/how-to-implement-composite-primary-keys-in-rails
  validates :user_id, uniqueness: { scope: [:period, :grau],
      message: "Apenas um Grau por período" }
```
[x] Tabela crib_indices adicionando score_crib automaticamente a partir do grau (validar esta regra com Jaime)

```
# Acrescentado um befor_action no model score_crib

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
```

[x] Customizando nome do app

```
initializers/rails_admin config file

config.main_app_name = ["Fhemig em Números", "Lançamentos Manuais"]
```

[x] Acrescentando links personalizados

```
initializers/rails_admin config file

config.navigation_static_links = {
  'Tutoriais' => 'https://youtube.com' # APONTAR PARA REPO YOUTUBE COM OS TUTORIAIS DE CADA TABELA
}

config.navigation_static_label = "Lins Úteis"
```

[x] Implementando Tradução da ferramenta

```
arquivos config/enviroments/production e development

config.i18n.enforce_available_locales = false
config.i18n.available_locales = ["pt-BR"]
config.i18n.default_locale = :'pt-BR'
```

criação dos arquivos enviroments/locales/pt-BR.yml e enviroments/locales/devise.pt-BR.yml (prestar atenção no padrão para escrever o nome dos models. Sempre traduzir o nome dos atributos aqui e não na configuração de cada model)

[x] Personalizando a disposição dos itens no menu lateral

```
Para configuração dentro do próprio model

rails_admin do
    weight -1
end
```

[x] Trocando o padrão visual do template

Instalação de nova gem - https://github.com/rollincode/rails_admin_theme

[ ] Criar indice apache

- Criar model apache

```
terminal

$ rails g model ApacheIndex user:references period:string grau:string score_apache:string predicao_obitos:float numero_saidas:float numero_obitos_ocorridos:float numero_obitos_esperados:float
```

- ActiveRecord Vinculaçoes / Validaçoes / rails_admin Configuraçoes

```
# User Model
has_many :apache_indices
```

```
# ApacheIndex Model
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

# Rails admin configuraçoes grande - incluído no próprio model
```


- Incluir autorizaçoes da tabela no model ability (cancancan)

```
class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      if user.admin == false
        # https://stackoverflow.com/questions/44497687/a-gem-cancan-access-denied-maincontroller-dashboard?answertab=votes#tab-top
        can :dashboard, :all
        can :access, :rails_admin
        can :read, :dashboard
        can :read, User, id: user.id
        can :update, User, id: user.id
        can :manage, CribIndex, user: user
        can :manage, ApacheIndex, user: user
      elsif user.admin == true
        can :manage, :all
      end
    end
  end
end
```

- Traduzir nome da tabela e atributos no arquivo pt-BR.yml

- Configurar Model

# Funcionalidades para futuras versões
[] Trocar o e-mail dos seeds para e-mails verdadeiros de cada unidade
[] Usuário poderá recuperar senha
