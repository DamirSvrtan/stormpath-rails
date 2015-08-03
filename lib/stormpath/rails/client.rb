module Stormpath
  module Rails
    class Client
      class << self
        attr_accessor :connection
      end

      def self.create_stormpath_account(user)
        account = Stormpath::Resource::Account.new account_params(user)
        account = application.accounts.create account
      end

      def self.authenticate(user)
        application.authenticate_account build_username_password_request(user)
      end

      def self.reset_password(email)
        application.send_password_reset_email email
      end

      def self.account_params(user)
        account_params = user.attributes.select do |k, v|
          %W[given_name surname email username password].include?(k) && !v.nil?
        end

        account_params.merge!("password" => user.password) unless user.password.empty?
      end

      def self.application
        self.client.applications.get Stormpath::Rails.config.application
      end

      def self.client
        self.connection ||= Stormpath::Client.new(client_options)
      end

      def self.client_options
        Hash.new.tap { |options| options[:api_key_file_location] = Stormpath::Rails.config.api_key_file }
      end

      private

      def self.build_username_password_request(user)
        Stormpath::Authentication::UsernamePasswordRequest.new user.email, user.password
      end
    end
  end
end