defmodule Monitoring.Stores.Carrefour do
  use GenServer
  alias Monitoring.Schemas.MonitoringPrices, as: MP
  alias Monitoring.Stores.CarrefourRequests, as: CReq

  # Inicia o GenServer com nome registrado no Registry
  def start_link(params \\ %{}) do
    GenServer.start_link(__MODULE__, params, name: via_tuple(params[:name]))
  end

  # Inicializa o estado e continua a inicialização
  def init(initial_state) do
    {:ok, initial_state, {:continue, :init_state}}
  end

  # Configura o envio da primeira mensagem após 1 segundo
  def handle_continue(:init_state, state) do
    Process.send_after(self(), :main, 1000)
    {:noreply, state}
  end

  # Realiza a requisição de preço e insere os dados no banco
  def handle_info(:main, %{link: link, name: name, refresh_hour: rh} = state) do
    # Fetching the price
    price = CReq.fetch(link)

    # Inserindo no banco
    MP.insert(%{name: name, price: price, day: DateTime.utc_now(), store: "carrefour"})

    # Reagendamento da tarefa
    timer = Process.send_after(self(), :main, rh)

    # Atualiza o estado com o novo timer
    {:noreply, Map.put(state, :timer, timer)}
  end

  # Helper function para construir a tupla via_tuple
  defp via_tuple(name), do: {:via, Registry, {MonitoringRegistry, name}}
end
