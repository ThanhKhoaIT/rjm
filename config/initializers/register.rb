Sprockets.register_preprocessor('application/javascript', ::Rjm::JsProcessor.new)
Sprockets.register_preprocessor('text/css', ::Rjm::CssProcessor.new)
