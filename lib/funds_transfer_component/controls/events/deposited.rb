module FundsTransferComponent
  module Controls
    module Events
      module Deposited
        def self.example
          deposited = FundsTransferComponent::Messages::Events::Deposited.build

          deposited.funds_transfer_id = FundsTransfer.id
          deposited.withdrawal_id = Deposit.id
          deposited.account_id = Withdrawal::Deposit.id
          deposited.amount = Money.example
          deposited.time = Time::Effective.example
          deposited.processed_time = Time::Processed.example

          deposited
        end
      end
    end
  end
end
