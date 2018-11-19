require_relative '../../automated_init'

context "Handle Events" do
  context "Withdrawn" do
    context "Ignored" do
      handler = Handlers::Events.new

      withdrawn = Controls::Events::Withdrawn.example

      funds_transfer = Controls::FundsTransfer::Deposited.example
      assert(funds_transfer.deposited?)

      handler.store.add(funds_transfer.id, funds_transfer)

      deposit_client = Account::Client::Deposit.new
      handler.deposit = deposit_client

      handler.(withdrawn)

      writer = deposit_client.write

      deposit = writer.one_message do |event|
        event.instance_of?(Account::Client::Messages::Commands::Deposit)
      end

      test "Deposit command is not written" do
        assert(deposit.nil?)
      end
    end
  end
end
