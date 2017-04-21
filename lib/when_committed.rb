require 'when_committed/version'

module WhenCommitted
  module ActiveRecord
    def when_committed(run_now_if_no_transaction: false, &block)
      if self.class.connection.current_transaction.open?
        cb = CallbackRecord.new(&block)
        self.class.connection.current_transaction.add_record(cb)
      else
        if run_now_if_no_transaction
          block.call
        else
          raise RequiresTransactionError
        end
      end
    end
  end

  # Adheres to the "record" duck type expected by the `add_record` method on
  # ActiveRecord::ConnnectionAdapters::Transaction
  # https://github.com/rails/rails/blob/4-2-stable/activerecord/lib/active_record/connection_adapters/abstract/transaction.rb
  class CallbackRecord
    def initialize(&callback)
      @callback = callback
    end

    def committed!(should_run_callbacks=true)
      # should_run_callbacks will only be false if we're in the process of
      # raising an exception (caused by another callback) and AR is giving us
      # a chance to clean up any internal state.
      # We should be consistent with ActiveRecord and *not* run the remaining
      # callbacks>
      if should_run_callbacks
        @callback.call
      end
    end

    def rolledback!(*)
    end
  end

  class RequiresTransactionError < StandardError
    HELP = "Specify `run_now_if_no_transaction: true` if you want to allow the block to run immediately when there is no transaction.".freeze

    def initialize(message=nil, *args)
      super(message||HELP, *args)
    end
  end
end
