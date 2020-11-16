module ActsAsTenant
  module ControllerExtensions
    module Subdomain
      extend ActiveSupport::Concern

      included do
        cattr_accessor :tenant_class, :tenant_column
        before_action :find_tenant_by_subdomain
        helper_method :current_tenant if respond_to?(:helper_method)
      end

      private

      def find_tenant_by_subdomain
        if request.subdomains.last
          ActsAsTenant.current_tenant = tenant_class.where(tenant_column => request.subdomains.last.downcase).first
        end
      end

      def current_tenant
        ActsAsTenant.current_tenant
      end
    end
  end
end
