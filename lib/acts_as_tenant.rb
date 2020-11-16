require "request_store"

require "acts_as_tenant/version"
require "acts_as_tenant/errors"

module ActsAsTenant
  autoload :Configuration, "acts_as_tenant/configuration"
  autoload :ControllerExtensions, "acts_as_tenant/controller_extensions"
  autoload :ModelExtensions, "acts_as_tenant/model_extensions"
  autoload :TenantHelper, "acts_as_tenant/tenant_helper"

  @@configuration = nil

  def self.configure
    @@configuration = Configuration.new
    yield configuration if block_given?
    configuration
  end

  def self.configuration
    @@configuration || configure
  end
end

ActiveSupport.on_load(:active_record) do |base|
  base.include ActsAsTenant::ModelExtensions
end

ActiveSupport.on_load(:action_controller) do |base|
  base.extend ActsAsTenant::ControllerExtensions
  base.include ActsAsTenant::TenantHelper
end

ActiveSupport.on_load(:action_view) do |base|
  base.include ActsAsTenant::TenantHelper
end
