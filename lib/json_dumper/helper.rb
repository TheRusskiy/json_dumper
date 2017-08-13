module JsonDumper
  module Helper
    def render_dumper_json(hash)
      render json: dumper_json(hash)
    end

    def dumper_json(hash)
      result = hash.map do |k, v|
        if v.is_a?(JsonDumper::Delayed)
          [k, dumper_fetch(v, camelcase: false)]
        else
          [k, v]
        end
      end.to_h
      KeyTransformer.keys_to_camelcase(result)
    end

    def dumper_fetch(delayed, camelcase: true)
      preload_hash = delayed.klass.send("#{delayed.method_name}_preload")
      preloader.preload(delayed.entity,preload_hash)
      result = delayed.klass.send(delayed.method_name, delayed.entity, *delayed.args)
      if camelcase
        result = KeyTransformer.keys_to_camelcase(result)
      end
      result
    end

    ############ PRIVATE ##############
    private

    def preloader
      ActiveRecord::Base::Preloader.new
    end
  end
end