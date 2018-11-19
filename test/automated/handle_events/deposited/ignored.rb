require_relative '../../automated_init'

context "Handle Events" do
  context "Deposited" do
    context "Ignored" do
      handler = Handlers::Events.new

      deposited = Controls::Events::Deposited.example

      funds_transfer = Controls::FundsTransfer::Transferred.example
      assert(funds_transfer.transferred?)

      handler.store.add(funds_transfer.id, funds_transfer)

      handler.(deposited)

      writer = handler.write

      transferred = writer.one_message do |event|
        event.instance_of?(FundsTransferComponent::Messages::Events::Transferred)
      end

      test "Transferred event is not written" do
        assert(transferred.nil?)
      end
    end
  end
end
