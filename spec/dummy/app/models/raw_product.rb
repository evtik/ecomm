class RawProduct < ApplicationRecord
  monetize :cost_cents

  alias_attribute :main_image, :image
  alias_attribute :title, :name
  alias_attribute :description, :desc
  alias_attribute :price, :cost

  mount_uploader :image, ImageUploader
end
