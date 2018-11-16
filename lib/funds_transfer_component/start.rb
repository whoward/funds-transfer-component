module FundsTransferComponent
  module Start
    def self.call
      Consumers::Commands.start('fundsTransfer:command')
      Consumers::Events.start('fundsTransfer')

      correlation_condition = "metadata->>'correlationStreamName' LIKE 'fundsTransfer-%'"
      Consumers::Account::Events.start('account', condition: correlation_condition)
    end
  end
end
