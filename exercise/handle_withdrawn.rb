require_relative 'exercise_init'

funds_transfer_id = Identifier::UUID::Random.get
stream_name = "fundsTransfer-#{funds_transfer_id}"

initiated = Messages::Events::Initiated.new.tap do |i|
  i.funds_transfer_id = funds_transfer_id
  i.withdrawal_account_id = Identifier::UUID::Random.get
  i.withdrawal_id = Identifier::UUID::Random.get
  i.deposit_id = Identifier::UUID::Random.get
  i.amount = 11
  i.time = '2000-01-01T11:11:11.000Z'
  i.processed_time = '2000-01-01T22:22:22.000Z'
end

pp initiated

Messaging::Postgres::Write.(initiated, stream_name)

MessageStore::Postgres::Read.(stream_name) do |message_data|
  Handlers::Events.(message_data)
  pp message_data
end

withdrawn = Messages::Events::Withdrawn.new.tap do |w|
  w.funds_transfer_id = funds_transfer_id
  w.withdrawal_id = initiated.withdrawal_id
  w.account_id = initiated.withdrawal_account_id
  w.amount = initiated.amount
  w.time = '2000-01-01T11:11:11.000Z'
  w.processed_time = '2000-01-01T22:22:22.000Z'
end

pp withdrawn

Messaging::Postgres::Write.(withdrawn, stream_name)

MessageStore::Postgres::Read.(stream_name) do |message_data|
  Handlers::Events.(message_data)
  pp message_data
end
