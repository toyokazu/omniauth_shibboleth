require 'rack'

module OmniAuth
  module Strategies
    class Shibboleth
      class Configuration

        DEFAULT_UID_ATTRIBUTE = 'eppn'

        attr_reader :uid_attr, :extra_attrs
        
        # @param [Hash] params configuration options
        # Shibboleth authentication is basically processed by SP. In OmniAuth Shibboleth Strategy, we mainly focus on attribute processing. The attribute names passed by SP is defined in shibd configuration file 'attribute-map.xml'.
        # @option params [String, nil] :uid_attr specifies SAML attribute name used as uid, e.g. eppn (eduPersonPrincipalName).
        # @option params [Array, nil] :extra_attrs specifies SAML attribute names obtained from environment variables and set to omni_hash extra field.
        # Example:
        #   :extra_attrs => ['affiliation', 'unscoped-affiliation', 'entitlement', 'organization']
        def initialize(params)
          parse_params params
        end

        private

        def parse_params(params)
          if params[:uid_attr].nil?
            raise ArgumentError.new(":uid_attr MUST be provided")
          end
          @uid_attr ||= params[:uid_attr] || DEFAULT_UID_ATTRIBUTE
          @extra_attrs ||= params[:extra_attrs] || []
        end

      end
    end
  end
end
