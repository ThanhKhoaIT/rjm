class Rjm::Fetchers

  def initialize(module_name)
    @module_name = module_name
    @module_content = nil
    create_cache_directory!
  end

  private

  attr_reader :module_name, :module_content

  def from_local_file!
    return false unless File.exists?(cache_file_name)
    @module_content = File.open(cache_file_name).read
    Rails.logger.debug("Loaded from #{cache_file_name}")
  end

  def create_cache_directory!
    Dir.mkdir('tmp/rjm-cached') unless Dir.exists?('tmp/rjm-cached')
  end

  def url_to_content(url)
    Rails.logger.debug("Downloading: #{url}")
    open(url).read
  end

  def cache_to_local!
    return if module_content.blank?
    Rails.logger.debug("Cache to #{cache_file_name}")
    File.write(cache_file_name, module_content)
  end

  def package_json
    prefix = {
      npm: "https://cdn.jsdelivr.net/npm/",
      unpkg: "https://unpkg.com/",
      bundle: "https://bundle.run/"
    }
    content = nil
    begin
      content = url_to_content("#{prefix[:npm]}#{module_name}/package.json")
    rescue
      content = url_to_content("#{prefix[:unpkg]}#{module_name}/package.json")
    rescue
      content = url_to_content("#{prefix[:bundle]}#{module_name}/package.json")
    rescue
      raise ::Rjm::Error.new("JSON: Can't get package.json of #{module_name}")
    end

    cache_package_json = "tmp/rjm-cached/#{module_name}.json"
    File.write(cache_package_json, content)
    JSON.parse(content)
  end

end
