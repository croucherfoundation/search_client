module SearchActiveResourceConfig
    extend ActiveSupport::Concern
  
    included do
      self.site                   = ENV['SEARCH_API_URL']
      self.prefix                 = '/api/'
      self.format                 = SearchFormatApiResponse
      self.include_format_in_path = false
    end
  end
  