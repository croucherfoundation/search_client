class CroucherDeindexJob < ActiveJob::Base

  def perform(klass, id, timestamp)
    if thing = klass.constantize.find(id)
      thing.remove_from_croucher_index!
    end
  end

end
