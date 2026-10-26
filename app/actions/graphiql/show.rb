require 'digest'

module Transponder
  module Actions
    module GraphiQL
      # Serves the GraphiQL IDE, loaded from a CDN, pointed at `POST /graphql`.
      class Show < Transponder::Action
        CDN = 'https://unpkg.com'.freeze

        SCRIPT = <<~JS.freeze
          const fetcher = GraphiQL.createFetcher({ url: '/graphql' });
          const root = ReactDOM.createRoot(document.getElementById('graphiql'));
          root.render(React.createElement(GraphiQL, { fetcher, defaultEditorToolsVisibility: true }));
        JS

        # The app-wide policy, plus the CDN, the inline `SCRIPT` and the `data:` fonts in GraphiQL's CSS.
        CONTENT_SECURITY_POLICY = [
          "base-uri 'self'",
          "connect-src 'self'",
          "default-src 'none'",
          "font-src 'self' data:",
          "form-action 'self'",
          "frame-ancestors 'self'",
          "img-src 'self' https: data:",
          "object-src 'none'",
          "script-src 'self' #{CDN} 'sha256-#{Digest::SHA256.base64digest(SCRIPT)}'",
          "style-src 'self' 'unsafe-inline' https:"
        ].join(';').freeze

        HTML = <<~HTML.freeze
          <!doctype html>
          <html lang="en">
            <head>
              <meta charset="utf-8">
              <meta name="viewport" content="width=device-width, initial-scale=1">
              <title>Transponder GraphiQL</title>
              <style>
                body { height: 100vh; margin: 0; overflow: hidden; }
                #graphiql { height: 100vh; }
              </style>
              <link rel="stylesheet" href="#{CDN}/graphiql@3.8.3/graphiql.min.css">
              <script src="#{CDN}/react@18.3.1/umd/react.production.min.js" crossorigin></script>
              <script src="#{CDN}/react-dom@18.3.1/umd/react-dom.production.min.js" crossorigin></script>
              <script src="#{CDN}/graphiql@3.8.3/graphiql.min.js" crossorigin></script>
            </head>
            <body>
              <div id="graphiql">Loading…</div>
              <script>#{SCRIPT}</script>
            </body>
          </html>
        HTML

        def handle(_request, response)
          response.format = :html
          response.headers['Content-Security-Policy'] = CONTENT_SECURITY_POLICY
          response.body = HTML
        end
      end
    end
  end
end
