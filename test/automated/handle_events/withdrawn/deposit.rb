require_relative '../../automated_init'

context "Handle Events" do
  context "Withdrawn" do
    context "Deposit" do
      handler = Handlers::Events.new

      deposit_client = Account::Client::Deposit.new
      handler.deposit = deposit_client

      processed_time = Controls::Time::Processed::Raw.example

      deposit_client.clock.now = processed_time

      withdrawn = Controls::Events::Withdrawn.example

      funds_transfer = Controls::FundsTransfer::Withdrawn.example

      handler.store.add(funds_transfer.id, funds_transfer)

      deposit_account_id = funds_transfer.deposit_account_id or fail
      deposit_id = funds_transfer.deposit_id or fail
      amount = funds_transfer.amount or fail

      withdrawn.metadata.correlation_stream_name = 'someCorrelationStream'

      account_command_stream_name = "account:command-#{deposit_account_id}"

      handler.(withdrawn)

      writer = deposit_client.write

      deposit = writer.one_message do |event|
        event.instance_of?(Account::Client::Messages::Commands::Deposit)
      end

      test "Deposit command is written" do
        refute(deposit.nil?)
      end

      test "Written to the account command stream" do
        written_to_stream = writer.written?(deposit) do |stream_name|
          stream_name == account_command_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "deposit_id" do
          assert(deposit.deposit_id == deposit_id)
        end

        test "account_id" do
          assert(deposit.account_id == deposit_account_id)
        end

        test "amount" do
          assert(deposit.amount == amount)
        end
      end

      context "Metadata" do
        test "Follows previous message" do
          assert(deposit.metadata.correlation_stream_name == withdrawn.metadata.correlation_stream_name)
        end
      end
    end
  end
end
