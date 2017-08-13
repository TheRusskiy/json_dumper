module JsonDumper
  class DumperHash < Hash
    attr_accessor :preload
    def initialize(hash)
      hash.each_pair do |k, v|
        self[k] = v
      end
    end

    def camel
      keys_to_camelcase
    end
  end
end