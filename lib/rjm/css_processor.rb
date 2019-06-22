class Rjm::CssProcessor

  def call(input)
    final_data = input[:data]
    rjm_modules = final_data.scan(/^\ ?\*= require_rjm (.*)$/).flatten
    return { data: final_data } if rjm_modules.empty?

    rjm_modules.each do |module_name|
      module_content = ::Rjm::Fetchers::Css.new(module_name).fetch_content
      module_content = "*/\n// Rjm required: #{module_name}\n#{module_content}\n/*"
      final_data.gsub!("*= require_rjm #{module_name}", module_content)
    end

    return { data: final_data }
  end

end
