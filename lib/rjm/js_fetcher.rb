class Rjm::JsFetcher

  def initialize(module_name)
    @module_name = module_name
    @module_content = nil
  end

  def fetch_content
    if from_local_file! || fetch_from_npm! || fetch_from_unpkg! || fetch_from_bundle!
      return module_content
    else
      raise Rjm::Error.new("require_rjm #{module_name} is failed")
    end
  end

  private

  attr_reader :module_name, :module_content

  def from_local_file!
    cache_file_name = cache_filename(module_name)
    is_cached = File.exists?(cache_file_name)
    @module_content = File.open(cache_file_name).read if is_cached
    Rails.logger.debug("Loading: #{module_name} from local")
  ensure
    return module_content.present?
  end

  def fetch_from_npm!
    url = "https://cdn.jsdelivr.net/npm/#{module_name}"
    @module_content = url_to_content(url)
    cache_to_local!
  ensure
    return module_content.present?
  end

  def fetch_from_unpkg!
    package_json_url = "https://unpkg.com/#{module_name}/package.json"
    package_json = JSON.parse(url_to_content(package_json_url))
    main_url = package_json['main']
    url = "https://unpkg.com/#{module_name}/#{main_url}"
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

  def url_to_content(url)
    Rails.logger.debug("Fetching: #{url}")
    open(url).read
  end

  def cache_to_local!
    return if module_content.blank?
    Rails.logger.debug("Caching: #{module_name} to local")
    File.write(cache_filename(module_name), module_content)
  end

  def cache_filename(module_name)
    Dir.mkdir('tmp/rjm-cached') unless Dir.exists?('tmp/rjm-cached')
    "tmp/rjm-cached/#{module_name}.js"
  end

end
