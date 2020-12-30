# Modificações/Adaptações do Modelo:

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
