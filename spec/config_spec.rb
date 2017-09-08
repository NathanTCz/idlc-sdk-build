require 'spec_helper'

module Idlc
  module Build
    describe Config do

      context 'no credentials' do

        before do
          ENV['AWS_ACCESS_KEY_ID'] = nil
          ENV['AWS_SECRET_ACCESS_KEY'] = nil
          ENV['VERSION_FILE'] = 'spec/idlc/deploy/test/version'
        end

        it 'exits if no credentials are supplied' do
          expect { Config.new(nil) }.to raise_error SystemExit
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
