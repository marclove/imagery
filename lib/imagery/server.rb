module Imagery
  class Server
    include SendFile

    NotFound = [404, {'Content-Type' => 'text/html'}, ['<h1>File not Found</h1>']].freeze

    def call(env)

      [SvgGenerator, ImageVariantGenerator].each do |generator|
        if image = generator.from_url(env['imagery.origin_host'], env['PATH_INFO'] + (env['QUERY_STRING'].empty? ? '' : "?#{env['QUERY_STRING']}"))

          return send_file(image)
        end
      end

      NotFound
    end
  end
end
