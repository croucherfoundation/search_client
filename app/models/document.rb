class Document
  include Her::JsonApi::Model
  use_api SEARCH_API
  collection_path "/api/documents"

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
      if file.is_a?(Paperclip::Attachment)
        self.content = get_and_read(file)
        self.content_type = file.content_type
        self.file_size = file.size
      end
    end
  end

  ## File reads
  #
  def get_and_read(file)
    if File.file?(file.path)
      content_from_path file.path
    elsif file.queued_for_write[:original]
      content_from_path file.queued_for_write[:original].path
    else
      tempfile_path = Rails.root.join("tmp/search/#{file.original_filename}")
      FileUtils.mkdir_p(Rails.root.join("tmp/search"))
      file.copy_to_local_file(:original, tempfile_path)
      outcome = content_from_path tempfile_path
      File.delete(tempfile_path) if File.file?(tempfile_path)
      outcome
    end
  rescue => e
    Rails.logger.warn "File read failure: #{e.message}"
    ""
  end

  def content_from_path(path)
    Yomu.new(path).text
  end

end

