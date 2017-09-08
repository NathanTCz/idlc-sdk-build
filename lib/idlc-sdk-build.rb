require 'date'
require 'fileutils'
require 'packer/binary'
require 'rspec/core/rake_task'
require 'securerandom'
require 'tmpdir'
require 'webrick'

# Use the packer-binary gem to provide the executable
Packer::Binary.configure do |config|
  config.version = '0.12.3'
end

require 'idlc-sdk-core'

require 'idlc-sdk-build/version'
require 'idlc-sdk-build/config'
require 'idlc-sdk-build/httpd'
require 'idlc-sdk-build/metadata'
require 'idlc-sdk-build/template'
