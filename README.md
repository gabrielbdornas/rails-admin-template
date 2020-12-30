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


[x] Customizando nome do app

```
initializers/rails_admin config file

config.main_app_name = ["Colocar Aqui", "| Nome do App"]
```

[x] Acrescentando links personalizados

```
initializers/rails_admin config file

config.navigation_static_links = {
  'Links' => 'https://google.com' # COLOCAR LINK DESEJADO
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

