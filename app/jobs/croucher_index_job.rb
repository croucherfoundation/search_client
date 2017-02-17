class CroucherIndexJob < ActiveJob::Base

  def perform(klass, id, timestamp)
    if thing = klass.constantize.find(id)
      unless !thing.respond_to?(:indexed_at) || (thing.indexed_at && thing.indexed_at.to_i > timestamp)
        thing.submit_to_croucher_index!
      end
    end
  end

end
