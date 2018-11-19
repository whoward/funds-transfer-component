require_relative '../../automated_init'

context "Handle Events" do
  context "Initiated" do
    context "Ignored" do
      handler = Handlers::Events.new

      initiated = Controls::Events::Initiated.example

      funds_transfer = Controls::FundsTransfer::Withdrawn.example
      assert(funds_transfer.withdrawn?)

      handler.store.add(funds_transfer.id, funds_transfer)

      withdraw_client = Account::Client::Withdraw.new
      handler.withdraw = withdraw_client

      handler.(initiated)

      writer = withdraw_client.write

      withdraw = writer.one_message do |event|
        event.instance_of?(Account::Client::Messages::Commands::Withdraw)
      end

      test "Withdraw command is not written" do
        assert(withdraw.nil?)
      end
    end
  end
end
