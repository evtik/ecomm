module Ecomm
  class ViewsGenerator < Rails::Generators::Base
    desc 'Copies Ecomm views'

    source_root(__dir__)

    def copy_views
      directory('../../../app/views/ecomm', 'app/views/ecomm')
    end
  end
end
