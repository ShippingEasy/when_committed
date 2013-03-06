# WhenCommitted

Provides `#when_commited` to run instance-specific code in `#after_commit`

## Installation

Add this line to your application's Gemfile:

    gem 'when_committed'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install when_committed

## Usage

Call `#when_committed` with a block of code that should run when the transaction
is committed:

    def update_score(new_score)
        self.score = new_score
        when_committed { Resque.enqueue(RecalculateAggregateScores, self.id) }
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
