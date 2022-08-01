module Indexed
  extend ActiveSupport::Concern

  included do
    after_save :enqueue_for_croucher_indexing, if: :croucher_index_auto?
    after_destroy :enqueue_for_croucher_deindexing
  end

  def document
    unless @document
      if respond_to?(:index_uid) && index_uid.present?
        @document = Document.find(index_uid)
      else
        @document = Document.new_with_defaults
      end
    end
    @document
  end

  def enqueue_for_croucher_indexing
    CroucherIndexJob.perform_later(self.class.to_s, id, Time.now.to_i)
  end
  #
  # ↓ async
  #
  def submit_to_croucher_index!
    if croucher_indexable?
      doc = self.document || Document.new_with_defaults
      doc.attributes.deep_merge!(croucher_index_data)
      if doc.save
        if respond_to?(:index_uid)
          update_column :index_uid, doc.uid
        end
      else
        Rails.logger.warn "INDEX FAIL"
      end
    end
  end

  def enqueue_for_croucher_deindexing
    CroucherDeindexJob.perform_later(self.class.to_s, id, Time.now.to_i)
  end
  #
  # ↓ async
  #
  def remove_from_croucher_index!
    if self.document.persisted?
      self.document.destroy
    elsif croucher_index_url.present?
      stem = '/api/documents'
      url = CGI::escape(croucher_index_url)
      Document.delete("#{stem}/url/#{url}")
    end
  end

  def croucher_index_data
    {
      title: croucher_index_title,
      professional_name: croucher_index_professional_name,
      chinese_name: croucher_index_chinese_name,
      url: croucher_index_url,
      document_type: croucher_index_document_type,
      content: croucher_index_content,
      content_url: croucher_index_content_url,
      content_type: croucher_index_content_type,
      published_at: croucher_index_date,
      confidentiality: croucher_index_confidentiality,
      terms: croucher_index_terms,
      file: croucher_index_file
    }
  end

  def croucher_indexable?
    true
  end

  def croucher_index_auto?
    true
  end

  def croucher_index_title
    read_attribute :title
  end

  def croucher_index_professional_name
    nil
  end

  def croucher_index_chinese_name
    nil
  end

  def croucher_index_content
    nil
  end

  def croucher_index_content_url
    nil
  end

  def croucher_index_content_type
    nil
  end

  def croucher_index_document_type
    "page"
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
