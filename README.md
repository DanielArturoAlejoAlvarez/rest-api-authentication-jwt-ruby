# REST API Authentication Rails-JWT V1.0

## Description

This repository is a Software of Application with Rails,JWT,PostgreSQL,etc

## Installation

Using Ruby 2.7, Rails 6.0 preferably.

## Software

Ruby Version Manager RVM 1.29.10-next

## Database

Using PostgreSQL

## Apps

Client Rest: Postman, Insomnia, Talend API Tester, etc

## Plugins

You can use the gems JWT, Carrierwave, Bcrypt, Rack-Cors, etc


## Usage

```html
$ git clone https://github.com/DanielArturoAlejoAlvarez/rest-api-authentication-jwt-ruby[NAME APP]

$ bundle install

$ rails db:migrate

$ rails s

```

Follow the following steps and you're good to go! Important:

![alt text](https://s3.amazonaws.com/com.twilio.prod.twilio-docs/original_images/ruby-api-json-parse.gif)

## Coding

### Routes
```ruby
...
namespace :api do
  namespace :v1 do
    resources :users, param: :_username

    namespace :auth do
      post '/login', to: 'authentication#login'
    end
  end
end

get '/*a', to: 'application#not_found'
...
```

### Middlewares
```ruby
...
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete]
  end
end
...
```

### Controllers
```ruby
...
def login
  @user = User.find_by_email(params[:email])
  if @user&.authenticate(params[:password])
    token = JsonWebToken.encode({user_id: @user.id})
    time = Time.now + 24.hours.to_i
    render json: {
      token: token,
      exp: time.strftime("%m-%d-%Y %H:%M"),
      username: @user.username
    }, status: :ok
  else
    render json: { error: 'unauthorized' }, status: :unauthorized
  end
end
...
```

### Models
```ruby
...
has_secure_password
mount_uploader :avatar, AvatarUploader

validates :email, presence: true, uniqueness: true
validates :email,
          format: { with: URI::MailTo::EMAIL_REGEXP }

validates :username, presence: true, uniqueness: true

validates :password,
          length: { minimum: 6 },
          if: ->{ new_record? || !password.nil? }
...
```

### Libraries
```ruby
...
class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def self.encode(payload, exp=24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload,SECRET_KEY, 'HS256')
  end

  def self.decode token
    decoded = JWT.decode(token, SECRET_KEY, true, {algorithm: 'HS256'})[0]
    HashWithIndifferentAccess.new decoded
  end
end
...
```



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DanielArturoAlejoAlvarez/rest-api-authentication-jwt-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

```

```
