require_relative '../../automated_init'

context "Handle Events" do
  context "Deposited" do
    context "Transferred" do
      handler = Handlers::Events.new

      deposited = Controls::Events::Deposited.example

      funds_transfer = Controls::FundsTransfer::Deposited.example

      handler.store.add(funds_transfer.id, funds_transfer)

      funds_transfer_id = funds_transfer.id or fail
      withdrawal_account_id = funds_transfer.withdrawal_account_id or fail
      deposit_account_id = funds_transfer.deposit_account_id or fail
      withdrawal_id = funds_transfer.withdrawal_id or fail
      deposit_id = funds_transfer.deposit_id or fail
      amount = funds_transfer.amount or fail
      time = deposited.time or fail

      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"

      handler.(deposited)

      writer = handler.write

      transferred = writer.one_message do |event|
        event.instance_of?(FundsTransfer::Messages::Events::Transferred)
      end

      test "Transferred command is written" do
        refute(transferred.nil?)
      end

      test "Written to the funds transfer stream" do
        written_to_stream = writer.written?(transferred) do |stream_name|
          stream_name == funds_transfer_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "funds_transfer_id" do
          assert(transferred.funds_transfer_id == funds_transfer_id)
        end

        test "withdrawal_account_id" do
          assert(transferred.withdrawal_account_id == withdrawal_account_id)
        end

        test "deposit_account_id" do
          assert(transferred.deposit_account_id == deposit_account_id)
        end

        test "withdrawal_id" do
          assert(transferred.withdrawal_id == withdrawal_id)
        end

        test "deposit_id" do
          assert(transferred.deposit_id == deposit_id)
        end

        test "amount" do
          assert(transferred.amount == amount)
        end

        test "time" do
          assert(transferred.time == time)
        end
      end
    end
  end
end
