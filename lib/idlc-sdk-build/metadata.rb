module Idlc
  module Build
    class MissingMetadataFile < StandardError; end
    class MissingRequiredMetadataAttribute < StandardError; end

    class Metadata
      class MetadataAttribute
        attr_reader :key
        attr_reader :value

        def initialize(value, required = false)
          @value = value
          @required = required
        end

        def required?
          @required
        end

        def defined?
          !@value.nil?
        end
      end

      attr_reader :attributes

      def initialize(name, file = 'metadata')
        @name = name
        @file = file
        @attributes = {}

        # Required
        @attributes['build_stage'] = MetadataAttribute.new(nil, true)
        @attributes['chef_run_list'] = MetadataAttribute.new(nil, true)
        @attributes['instance_type'] = MetadataAttribute.new(nil, true)
        @attributes['os_type'] = MetadataAttribute.new(nil, true)
        @attributes['role'] = MetadataAttribute.new(nil, true)
        @attributes['source_ami_name'] = MetadataAttribute.new(nil, true)
        @attributes['source_ami_owner'] = MetadataAttribute.new(nil, true)
        @attributes['version'] = MetadataAttribute.new(REPO_VERSION, true)
        @attributes['security_group_id'] = MetadataAttribute.new(ENV['PACKER_BUILD_SG_ID'], true)
        @attributes['vpc_id'] = MetadataAttribute.new(ENV['PACKER_BUILD_VPC_ID'], true)
        @attributes['vpc_subnet'] = MetadataAttribute.new(ENV['PACKER_BUILD_SUBNET_ID'], true)
        @attributes['iam_instance_profile'] = MetadataAttribute.new(ENV['PACKER_BUILD_INSTANCE_PROFILE_NAME'], true)

        # Optional Defaults
        @attributes['block_device_mapping'] = MetadataAttribute.new('[]')
        @attributes['job_code'] = MetadataAttribute.new('988')
        @attributes['chef_dir'] = MetadataAttribute.new('c:/windows/temp/packer-chef-client')
      end

      def load
        raise MissingMetadataFile, "Expected metadata file at: #{metadata_file}" unless File.exist? metadata_file

        YAML.load_file(metadata_file).each do |key, value|
          value = nested_json(value) if key == 'block_device_mapping'

          value = strip_trailing_dash(value) if key == 'source_ami_name'

          puts "WARNING: unrecognized metadata key: '#{key}'" unless @attributes.key? key
          next unless @attributes.key? key

          required = @attributes[key].required?
          @attributes[key] = MetadataAttribute.new(value, required)
        end
      end

      def strip_trailing_dash(value)
        return value[0..-2] if dash? value[-1]

        value
      end

      def dash?(char)
        char == '-'
      end

      def nested_json(value)
        total_block = []
        value.each do |block|
          total_block.push(block)
        end

        total_block.to_json
      end

      def requirements_satisfied?
        begin
          @attributes['version'] = MetadataAttribute.new(YAML.load_file(version_file)['version'], true) unless @attributes['version'].defined?
        rescue
          puts('WARNING: \'version\' not specified in environment, metadata, or version file')
        end

        @attributes.each do |key, att|
          raise MissingRequiredMetadataAttribute, "Missing required key: '#{key}' in metadata file" if att.required? && att.value.nil?
          raise MissingRequiredMetadataAttribute, "Metadata key: '#{key}' cannot be nil" if att.required? && att.value.strip.empty?
        end

        true
      end

      def metadata_file
        "#{Dir.pwd}/#{base_dir}/#{@file}"
      end

      def version_file
        "#{Dir.pwd}/#{base_dir}/version"
      end

      def base_dir
        "builds/#{@name}"
      end
    end
  end
end
