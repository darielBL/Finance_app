ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "devise"

module ActiveSupport
  class TestCase
    parallelize(workers: 1)
    self.use_transactional_tests = true

    # Incluir helpers de Devise y Warden
    include Devise::Test::IntegrationHelpers
    include Warden::Test::Helpers

    # Configurar Warden para pruebas
    setup do
      Warden.test_mode!
    end

    teardown do
      Warden.test_reset!
    end
  end
end