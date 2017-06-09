module FundsTransferComponent
  module Start
    def self.call
      Consumers::Commands.start('fundsTransfer:command')
      Consumers::Events.start('fundsTransfer')
      Consumers::Account::Events.start('account')
    end
  end
end
