class Transaction < ApplicationRecord
  # Enums traduzidos para facilitar o uso no código e formulários
  enum :kind, { despesa: 0, venda: 1 }
  enum :frequency, { variavel: 0, fixa: 1 }

  # Escopos em português para o Dashboard
  scope :este_ano, -> { where(date: Date.current.all_year) }
  scope :este_mes, -> { where(date: Date.current.all_month) }
  scope :mes_passado, -> { where(date: Date.current.last_month.all_month) }
  scope :ultimos_3_meses, -> { where(date: 3.months.ago.to_date..Date.current) }
  scope :ultimos_6_meses, -> { where(date: 6.months.ago.to_date..Date.current) }
  scope :ano_passado, -> { where(date: Date.current.last_year.all_year) }

  # Lógica para o lucro recomendado
  def lucro_recomendado
    return 0 unless venda?
    value * (profit_margin / 100.0)
  end
end
