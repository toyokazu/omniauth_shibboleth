require 'omniauth/enterprise'

module OmniAuth
  module Strategies
    class Shibboleth
      include OmniAuth::Strategy
      
      autoload :Configuration, 'omniauth/strategies/shibboleth/configuration'
      
      def initialize(app, options = {}, &block)
        super(app, options[:name] || :shibboleth, options.dup, &block)
        @configuration = OmniAuth::Strategies::Shibboleth::Configuration.new(options)
      end
      
      protected
      
      def request_phase
        [ 
          302,
          {
            'Location' => callback_url,
            'Content-Type' => 'text/plain'
          },
          ["You are being redirected to Shibboleth SP/IdP for sign-in."]
        ]
      end

      def callback_phase
        #raise request.inspect
        #return fail!(:test_fail, 'This is test failure message.')
        shib_session_id = request.env['Shib-Session-ID']
        return fail!(:no_session, 'No Shibboleth Session') unless shib_session_id
        @user_info = {
          'uid' => request.env[@configuration.uid_attr],
          'extra' => request.env.reject {|k,v| !@configuration.extra_attrs.include?(k)}
        }
        return fail!(:invalid_session, 'Invalid Shibboleth Session') if @user_info.nil? || @user_info.empty?
        super
      end
      
      def auth_hash
        OmniAuth::Utils.deep_merge(super, @user_info)
      end

    end
  end
end
