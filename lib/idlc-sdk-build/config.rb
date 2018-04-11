module Idlc::Build
  class Config
    include Idlc::Helpers

    class << self
      include Idlc::Helpers

      def add_build_var(key, value)
        ENV[key] = value
      end
    end

    def initialize(region)
      @region = region
      @build_vars = []

      Idlc::Utility.check_for_creds

    rescue Idlc::Utility::MissingCredentials => e
      msg("WARN: #{e.message}\nFalling back to implicit authentication.")
    end

    def dump_build_vars
      @build_vars.join(' ')
    end

    def add_build_var_v2(key, value)
      ENV[key] = value

      @build_vars << "-var '#{key}=#{value}'"
    end
  end
end
