module Indexed
  extend ActiveSupport::Concern

  included do
    after_save :submit_to_croucher_index!
    after_destroy :remove_from_croucher_index!
  end

  def document
    if respond_to?(:index_uid) && index_uid
      Document.find(index_uid)
    end
  end

  def submit_to_croucher_index!
    doc = self.document || Document.new
    doc.assign_attributes(croucher_index_data)
    doc.save
  end

  def remove_from_croucher_index!
    if doc = self.document
      doc.destroy
    elsif croucher_index_url
      # DELETE to /api/index/url/:url
    end
  end

  def croucher_index_data
    {
      title: croucher_index_title,
      chinese_name: croucher_index_chinese_name,
      url: croucher_index_url,
      content: croucher_index_content,
      document_type: croucher_index_document_type,
      file: croucher_index_file,
      published_at: croucher_index_date,
      terms: croucher_index_terms,
      confidentiality: croucher_index_confidentiality
    }
  end

  def croucher_index_title
    read_attribute :title
  end

  def croucher_index_chinese_name
    nil
  end

  def croucher_index_content
    nil
  end

  def croucher_index_url
    nil
  end

  # Return a paperclip attachment object or a url.
  #
  def croucher_index_file
    nil
  end

  def croucher_index_date
    updated_at
  end

  def croucher_index_terms
    if respond_to? :terms
      terms
    else
      ""
    end
  end

  # "public", "private" or "confidential"
  #
  def croucher_index_confidentiality
    "private"
  end

end