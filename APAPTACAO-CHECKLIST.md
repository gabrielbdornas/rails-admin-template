# Modificações/Adaptações do Modelo:

[ ] Copiar e Colar Pasta do Projeto

[ ] Renomear pasta com novo nome do projeto

[ ] Apagar pasta .git

[ ] Criar nova pasta .git e sincronizar com github

```
# Terminal

$ git init
$ gc "commit inicial - criação do projeto"
$ hub create
$ git branch -M main
$ git push origin main
```

[ ] Trocar nome databases

```
# config/database.yml

development:
  <<: *default
  database: rails_admin_template_development

test:
  <<: *default
  database: rails_admin_template_test

production:
  <<: *default
  database: rails_admin_template_production
  username: rails_admin_template_
  password: <%= ENV['RAILS_ADMIN_TEMPLATE_DATABASE_PASSWORD'] %>
```

[ ] Finalizando adaptação

localizar todos "rails_admin_template", "rails-admin-template" e "RailsAdminTemplate" e substituir pelo nome do projeto

[ ] Customizar nome do app

```
initializers/rails_admin config file

config.main_app_name = ["Colocar Aqui", "| Nome do App"]
```

[ ] Customizar Página de Login

```
app/views/devise/sessions new file

<h3>RAILS ADMIN TEMPLATE</h3>
```

[ ] Criar Banco

```
# terminal
$ rails db:create db:migrate db:seed
```

[ ] Criação Models:

1 - Criar Mode

```
# Terminal

rails g model ModelSingularName mode_atribute:string
```

2 - Configurar campos Model

```
# model file

class ModelSingularName

  rails_admin do
    show do
      field  :model_atribute
    end
    list do
      field  :model_atribute
    end
    edit do
      field  :model_atribute
    end
  end
end
```

3 - Liberar Acesso CanCanCan

```
# ability class

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
        # can :manage, ModelSingularName, user: user
      elsif user.admin == true
        can :manage, :all
      end
    end
  end
end
```

4 - Tradução Model

```
# config/locales/pt-BR.yml

activerecord:
    models:
      user:
        one: "Usuário"
        other: "Usuários"
    attributes:
      user:
        name: "Nome"
        admin: "Administrador"
        email: "Email"
        password: "Senha"
        password_confirmation: "Confirmação Senha"

```
