require_relative 'authorization'

module EasyTokens
  class Engine < ::Rails::Engine
    isolate_namespace EasyTokens

    initializer 'easy_tokens.controller_extensions' do
      ActionController::Base.send(:include, EasyTokens::Authorization)
    end
  end
end
