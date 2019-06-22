class Rjm::Fetchers::Json < ::Rjm::Fetchers

  def json
    if from_local_file! || fetch_from_npm! || fetch_from_unpkg! || fetch_from_bundle!
      return JSON.parse(module_content)
    else
      raise Rjm::Error.new("Rjm: #{module_name} can't get package.json file")
    end
  end

  private

  def fetch_from_npm!
    url = "https://cdn.jsdelivr.net/npm/#{module_name}/package.json"
    @module_content = url_to_content(url)
    cache_to_local!
  ensure
    return module_content.present?
  end

  def fetch_from_unpkg!
    url = "https://unpkg.com/#{module_name}/package.json"
    @module_content = url_to_content(url)
    cache_to_local!
  ensure
    return module_content.present?
  end

  def fetch_from_bundle!
    url = "https://bundle.run/#{module_name}/package.json"
    @module_content = url_to_content(url)
    @module_content = nil if @module_content == 'invalid module'
    cache_to_local!
  ensure
    return module_content.present?
  end

  def cache_file_name
    "tmp/rjm-cached/#{module_name}.json"
  end

end
