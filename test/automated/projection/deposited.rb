require_relative '../automated_init'

context "Projection" do
  context "Deposited" do
    funds_transfer = Controls::FundsTransfer::Withdrawn.example

    assert(funds_transfer.deposited_time.nil?)
    refute(funds_transfer.deposited?)

    deposited = Controls::Events::Deposited.example

    deposited_time_iso8601 = deposited.time or fail

    Projection.(funds_transfer, deposited)

    test "Deposited time is converted and set" do
      deposited_time = Clock.parse(deposited_time_iso8601)

      assert(funds_transfer.deposited_time == deposited_time)
    end
  end
end
