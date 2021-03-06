require 'spec_helper'

module Idlc
  module Build
    describe Config do

      context 'no credentials' do

        before do
          ENV['VERSION_FILE'] = 'spec/idlc/deploy/test/version'
        end

      end

      it 'adds vars to environment' do
        Config.add_build_var('key', 'value')
        expect(ENV.include?('key')).to eq true
        expect(ENV['key']).to eq 'value'
      end

    end
  end
end
