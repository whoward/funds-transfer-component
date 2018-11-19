module FundsTransferComponent
  module Handlers
    class Events
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Commands
      include Messages::Events

      dependency :withdraw, ::Account::Client::Withdraw
      dependency :deposit, ::Account::Client::Deposit
      dependency :store, Store

      def configure
        ::Account::Client::Withdraw.configure(self)
        ::Account::Client::Deposit.configure(self)
        Store.configure(self)
      end

      category :funds_transfer

      handle Initiated do |initiated|
        transfer = store.fetch(initiated.funds_transfer_id)

        if transfer.withdrawn?
          logger.info(tag: :ignored) { "Command ignored (Command: #{initiated.message_type}, Funds Transfer ID: #{transfer.id}" }
          return
        end

        account_id = initiated.withdrawal_account_id
        withdrawal_id = initiated.withdrawal_id
        amount = initiated.amount

        withdraw.(
          withdrawal_id: withdrawal_id,
          account_id: account_id,
          amount: amount,
          previous_message: initiated
        )
      end

      handle Withdrawn do |withdrawn|
        transfer = store.fetch(withdrawn.funds_transfer_id)

        if transfer.deposited?
          logger.info(tag: :ignored) { "Command ignored (Command: #{withdrawn.message_type}, Funds Transfer ID: #{transfer.id}" }
          return
        end

        deposit_id = transfer.deposit_id
        account_id = transfer.deposit_account_id
        amount = transfer.amount

        deposit.(
          deposit_id: deposit_id,
          account_id: account_id,
          amount: amount,
          previous_message: withdrawn
        )
      end
    end
  end
end
