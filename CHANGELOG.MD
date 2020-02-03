# Changelog

## 1.0.2

* Add trigger_transactional_callbacks? method for Rails 6.0 compatibility

## 1.0.1

* Restore support for callbacks defined within nested transactions
* Drop support for removed raise_in_transactional_callbacks options

## 1.0.0

* Add a dependency on active_record >= 5.1
* Add no_op `before_committed!` and `add_to_transaction` methods to `WhenCommitted::CallbackRecord` for Rails 5.1 compatibility
  The `ActiveRecord::ConnectionAdapters::Transaction` API changed to now expect "record-like" objects to respond to these methods
* Update `committed!` to accept keyword arguments for Rails 5.1 compatibility
