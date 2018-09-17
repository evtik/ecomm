# Ecomm
Ecomm is a Rails Engine that provides a shopping cart and checkout functionality to your web app to turn it into an online store. The cart has the ability to show, add or remove the chosen products and also to change their quantities. The checkout appears as a 5-step wizard allowing a user to consequtively submit his 1) addresses, 2) desired shipment method, 3) payment details, 4) confirmation and 5) it shows the complete order page with all the details and sends the corresponding email.

## Installation
To start add this line to your application's Gemfile:

```ruby
gem 'ecomm', github: 'evtik/ecomm', branch: 'develop'
```

And then execute:
```bash
$ bundle
```
Next run the `install` generator with:
```bash
$ rails generate ecomm:install
```
You will be asked a bunch of questions based on which you will get your Ecomm configuration saved in `config/initializers/ecomm.rb`. This file may be edited afterwards if there is a need to change a particular setting. So, here they are step by step.

  1. The model representing a user in your app. Typically, it is `User` and that's the default option. In the initializer it adds:
  ```ruby
  config.customer_class = 'User'
  ```
  2. The model representing a product in your app:
  ```ruby
  config.product_class = 'Book'
  ```
  3. Ecomm does not have its own authentication system. It's totally your choice what to use: be it Devise, Authlogic, Clearance, Sorcery or even your custom one. You just need to provide some key points to make Ecomm use your authentication engine. First of them is the name of the method that returns the current authenticated user (if there is one) in your app. For instance, Devise's one is called `current_user` (considering the model is `User`) and that is used by default:
  ```ruby
  config.current_customer_method = 'current_user'
  ```
  4. Next you will have to provide the path for an unauthenticated user to sign in as any checkot process presumes existing a particular customer. The default option is Devise's `/users/sign_in`:
  ```ruby
  config.signin_path = '/users/sign_in'
  ```
  5. The name of the flash key which keeps the current path. This is used by your authentication engine on friendly forwarding: when an unauthenticated user tries to hit the page that requires authentication he will be forwarded to the sign in page first and this key holds the target page path to forward to after a successful sign in. The default one is, again, for Devise:
  ```ruby
  config.flash_login_return_to = 'user_return_to'
  ```
  6. The last option regarding authentication is the `I18n` key that holds the translation of the *'Authentication required'* message shown on the sign in page on friendly forwarding. The default is Devise's:
  ```ruby
  config.i18n_unuathenticated_key = 'devise.failure.unauthenticated'
  ```
  7. Path to your products' catalog. Actually, it may be any path you want to forward a user after a completed checkout. This path is also used in the link on the cart page when the cart is empty. The default option is pretty arbitrary:
  ```ruby
  config.catalog_path = '/home/index'
  ```
  8. Ecomm mailer sends an email to the user after the order is completed. Among other details it contains a link pointing to the order details within your app, so the user may see the order's details, totals, status, etc. This means there should exist a kind of orders controller in your app. This setting requires the appropriate route helper's name. `order_url` is used as default:
  ```ruby
  config.completed_order_url_helper_method = 'order_url'
  ```
  Once you don't feel it is necessary to include the link in the email, you may generate Ecomm views with
  ```bash
  $ rails generate ecomm:views
  ```
  and remove the order link from the order mailer's template.

  9. The final question is whether you want to run the copied Ecomm migrations right away. If there is a reason not to do so do not forget to run them later with:
```bash
$ rails db:migrate SCOPE=ecomm
```

Besides the above steps the installer will also copy Ecomm translations, require assets, mount routes with the default path prefix `/store` and patch `User` model by adding this lines:
```ruby
  has_many :addresses, class_name: 'Ecomm::Address',
                       foreign_key: :customer_id, dependent: :destroy
```
This is needed because Ecomm tries to be smart so when a user comes to the first checkout step that requires addresses those addresses are first looked up as associated with the user. This means you might use `Ecomm::Address` to store a user's default addresses, say, as a part of user settings.
## Configuration
Ecomm expects your `Product` model to have the following fields - `main_image`, `title`, `description` and `price` - since this is how `Product` is bound to the cart and checkout views. If you have those fields named in some other way you should set the connection with the `alias_attribute` method:
``` ruby
  class MyProduct < ApplicationRecord
    #...
    alias_attribute :main_image, :main_image_like_attribute
    alias_attribute :title, :title_like_attribute
    alias_attribute :description, :description_like_attribute
    alias_attribute :price, :price_like_attribute
    #...
  end
  ```

Once you feel the necessity to ***extend*** (not to overwrite) some of the Ecomm classes you may use `Ecomm::Engine.<types>_path(name)` helper method to require a class for monkey patching. For instance, if it is needed to patch the `Ecomm::Order` model just create `app/models/ecomm/order.rb` with:
```ruby
require Ecomm::Engine.models_path(:order)

module Ecomm
  class Order
    include AASM # or whatever you like
    # ...
    end
  end
end
```
The same technique can be applied to controllers, presenters, queries, etc. In general, for each folder in `Ecomm`'s `app/` folder except `assets/`, `jobs/` and `views/`as for the above it obviously makes no sense.

The default path prefix `/store` may be changed in `config/routes.rb`:
```ruby
  Rails.application.routes.draw do
    # ...
    mount Ecomm::Engine => '/store'
    # ...
  end
```
If there is a need to change translations feel free to edit the copied `config/locales/ecomm.en.yml`.

To generate Ecomm views (in a case you want to apply some custom styling or change layout) just run:
```bash
$ rails generate ecomm:views
```
and find them in `app/views/ecomm`.

## Testing

For feature specs in your app you can use Ecomm's `FactoryBot` factories with just requiring them with
``` ruby
require 'ecomm/factories'
```
where you need them.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
