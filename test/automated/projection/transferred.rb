require_relative '../automated_init'

context "Projection" do
  context "Transferred" do
    funds_transfer = Controls::FundsTransfer::Deposited.example

    assert(funds_transfer.transferred_time.nil?)
    refute(funds_transfer.transferred?)

    transferred = Controls::Events::Transferred.example

    transferred_time_iso8601 = transferred.time or fail

    Projection.(funds_transfer, transferred)

    test "Transferred time is converted and set" do
      transferred_time = Clock.parse(transferred_time_iso8601)

      assert(funds_transfer.transferred_time == transferred_time)
    end
  end
end
