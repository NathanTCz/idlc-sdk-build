module Idlc
  module Build
    class Template
      def initialize(metadata, output_file)
        @metadata = metadata
        @output_file = output_file
      end

      def templates_dir
        "#{__dir__}/templates/#{@metadata['build_stage'].value}"
      end

      def render
        tpl = File.read("#{templates_dir}/build.json.erb")

        renderer = ERB.new(tpl)
        renderer.result(binding)
      end

      def write
        # Write rendered template to output_file
        File.open(@output_file, 'w') { |file| file.write(render) }
      end
    end
  end
end
