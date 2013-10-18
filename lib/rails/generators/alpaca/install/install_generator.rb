module Alpaca
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc 'Copies an Alpaca configuration file to your application.'

      def copy_configuration
        copy_file 'alpaca.yml', 'config/alpaca.yml'
      end
    end
  end
end
