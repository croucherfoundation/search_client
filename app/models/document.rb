class Document
  include Her::JsonApi::Model
  use_api SEARCH_API
  collection_path "/api/documents"

  primary_key :uid

  include_root_in_json true
  parse_root_in_json false

  def self.new_with_defaults(attributes={})
    Document.new({
      title: "",
      chinese_name: "",
      url: "",
      document_type: "",
      content: "",
      content_type: "",
      published_at: "",
      confidentiality: "",
      terms: ""
    }.merge(attributes))
  end

  def file=(file)
    if file
      if file.is_a?(ActiveStorage::Attached::One)
        self.content = get_and_read(file)
        self.content_type = file.content_type
        self.file_size = file.byte_size
      end
    end
  end

  ## File reads
  #
  def get_and_read(file)
    return "" unless file&.attached?

    begin
      file.open do |tempfile|
        content_from_path tempfile.path
      end
    rescue => e
      Rails.logger.warn "File read failure: #{e.message}"
      ""
    end
  end

  def content_from_path(path)
    Henkei.new(path).text
  end

end
