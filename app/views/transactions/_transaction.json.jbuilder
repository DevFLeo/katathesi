json.extract! transaction, :id, :description, :value, :category, :kind, :frequency, :date, :profit_margin, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
