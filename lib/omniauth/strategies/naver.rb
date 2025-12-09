require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Naver < OmniAuth::Strategies::OAuth2
      option :name, 'naver'
      
      option :client_options, {
        :site => 'https://nid.naver.com',
        :authorize_url => 'https://nid.naver.com/oauth2.0/authorize',
        :token_url => 'https://nid.naver.com/oauth2.0/token'
      }

      def request_phase
        super
      end

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      uid { raw_info['response']['id'] }

      info do
        {
          'name' => raw_info['response']['name'],
          'email' => raw_info['response']['email'],
          'image' => raw_info['response']['profile_image']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= access_token.get('https://openapi.naver.com/v1/nid/me', {
          :headers => { 'Authorization' => "Bearer #{access_token.token}" }
        }).parsed
      end
    end
  end
end