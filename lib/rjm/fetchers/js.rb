class Rjm::Fetchers::Js < ::Rjm::Fetchers

  def fetch_content
    if from_local_file! || fetch_from_npm! || fetch_from_unpkg! || fetch_from_bundle!
      return module_content
    else
      raise Rjm::Error.new("JS: require_rjm #{module_name} is failed")
    end
  end

  private

  def fetch_from_npm!
    url = "https://cdn.jsdelivr.net/npm/#{module_name}"
    @module_content = url_to_content(url)
    cache_to_local!
  ensure
    return module_content.present?
  end

  def fetch_from_unpkg!
    json = ::Rjm::Fetchers::Json.new(module_name).json
    url = "https://unpkg.com/#{module_name}/#{json['main']}"
    @module_content = url_to_content(url)
    cache_to_local!
  ensure
    return module_content.present?
  end

  def fetch_from_bundle!
    url = "https://bundle.run/#{module_name}"
    @module_content = url_to_content(url)
    @module_content = nil if @module_content == 'invalid module'
    cache_to_local!
  ensure
    return module_content.present?
  end

  def cache_file_name
    "tmp/rjm-cached/#{module_name}.js"
  end

end
