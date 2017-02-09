class Document
  include Her::JsonApi::Model
  use_api SEARCH_API
  collection_path "/api/documents"

  include_root_in_json true
  parse_root_in_json false

  def file=(file)
    if file
      with_local(file) do |path|
        self.content = Yomu.new(path).text
      end
      if file.is_a?(Paperclip::Attachment)
        self.content_type = file.content_type
        self.file_size = file.file_size
      end
    end
  end

  ## File reads
  #
  def with_local(file)
    if file.is_a?(Paperclip::Attachment)
      #
      # retrieve local file from pipeline if possible
      #
      if File.file?(file.path)
        yield file.path
      elsif file.queued_for_write[:original]
        yield file.queued_for_write[:original].path
      else
        #
        # or pull down from S3
        #
        tempfile_path = copy_to_local(file)
        yield tempfile_path
        File.delete(tempfile_path) if File.file?(tempfile_path)
      end

    else
      # fetch from remote url and yield
    end

  end

  def copy_to_local(file)
    if file?
      begin
        folder = self.class.to_s.downcase.pluralize
        tempfile_path = Rails.root.join("tmp/#{folder}/#{id}/#{file_file_name}")
        FileUtils.mkdir_p(Rails.root.join("tmp/#{folder}/#{id}"))
        file.copy_to_local_file(:original, tempfile_path)
      rescue => e
        Rails.logger.warn "File read failure: #{e.message}"
      end
      tempfile_path
    end
  end

end

