module YARD
  module Server
    class DocServerSerializer < Serializers::FileSystemSerializer
      def initialize(command)
        super(:command => command, :extension => '')
      end

      def serialized_path(object)
        path = case object
        when CodeObjects::RootObject
          "toplevel"
        when CodeObjects::MethodObject
          namespace = object.namespace.is_a?(CodeObjects::RootObject) ? 'toplevel' : super(object.namespace)
          namespace + (object.scope == :instance ? ":" : ".") + object.name.to_s
        else
          super(object)
        end
        command = options[:command]
        library_path = command.single_library ? '' : '/' + command.library.to_s
        return File.join('/docs' + library_path, path)
      end
    end
  end
end