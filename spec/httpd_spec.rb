require 'spec_helper'

module Idlc
  module Build
    describe Httpd do

      # Define Public interface
      it { should respond_to(:start) }
      it { should respond_to(:stop) }
      it { should respond_to(:private_ip) }

    end
  end
end
