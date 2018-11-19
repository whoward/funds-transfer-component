module FundsTransferComponent
  module Controls
    module Commands
      module Transfer
        def self.example
          transfer = FundsTransferComponent::Messages::Commands::Transfer.build

          transfer.funds_transfer_id = FundsTransfer.id
          transfer.withdrawal_account_id = Withdrawal::Account.id
          transfer.deposit_account_id = Deposit::Account.id
          transfer.withdrawal_id = Withdrawal.id
          transfer.deposit_id = Deposit.id
          transfer.amount = Money.example
          transfer.time = Time::Effective.example

          transfer
        end
      end
    end
  end
end
