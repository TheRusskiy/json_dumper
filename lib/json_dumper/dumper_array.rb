module JsonDumper
  class DumperArray < Array
    attr_accessor :preload

    def camel
      JsonDumper::KeyTransformer.keys_to_camelcase_array(self)
    end
  end
end