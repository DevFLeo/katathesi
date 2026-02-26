class DashboardController < ApplicationController
  layout "dashboard"

  def index
    # Definir o período (padrão: ano atual)
    @periodo = params[:periodo] || "ano"
    
    # Seleciona as transações baseadas no período escolhido usando os novos escopos
    transacoes_atuais = case @periodo
                        when "mes"      then Transaction.este_mes
                        when "semestre" then Transaction.ultimos_6_meses
                        when "ano"      then Transaction.este_ano
                        else Transaction.este_ano
                        end

    # Totais do Período Atual
    @total_receita = transacoes_atuais.venda.sum(:value)
    @total_despesa = transacoes_atuais.despesa.sum(:value)
    @lucro_liquido = @total_receita - @total_despesa
    
    # Lucro Recomendado (Cálculo direto no SQL para performance)
    @lucro_recomendado = transacoes_atuais.venda.sum("value * (profit_margin / 100.0)")

    # Comparação com o Mês Anterior (Para os indicadores "vs mês anterior")
    vendas_mes_passado = Transaction.mes_passado.venda.sum(:value)
    @variacao_receita = calcular_variacao(@total_receita, vendas_mes_passado)

    # Dados para os Gráficos (Sempre baseados no ano atual para preencher o gráfico de JAN a DEZ)
    transacoes_ano = Transaction.este_ano
    receitas_por_mes = transacoes_ano.venda.group("EXTRACT(MONTH FROM date)").sum(:value)
    despesas_por_mes = transacoes_ano.despesa.group("EXTRACT(MONTH FROM date)").sum(:value)

    @meses = I18n.t("date.abbr_month_names").compact.map(&:upcase)
    @receitas_mensais = (1..12).map { |m| receitas_por_mes[m.to_f] || 0 }
    @despesas_mensais = (1..12).map { |m| despesas_por_mes[m.to_f] || 0 }
    @saldos_mensais = (1..12).map { |m| (receitas_por_mes[m.to_f] || 0) - (despesas_por_mes[m.to_f] || 0) }

    # Margem de Lucro Real para o gráfico de rosca
    @margem_lucro_real = @total_receita > 0 ? (@lucro_liquido / @total_receita) * 100 : 0

    render "home/index"
  end

  private

  def calcular_variacao(atual, anterior)
    return 0 if anterior == 0
    ((atual - anterior) / anterior.to_f) * 100
  end
end
