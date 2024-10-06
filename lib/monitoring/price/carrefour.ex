defmodule Monitoring.Price.Carrefour do
  use GenServer
  alias Monitoring.Schemas.Carrefour, as: SCarrefour

  @verify 12 * 60 * 60 * 1000 # hours
  @lava_e_seca "https://www.carrefour.com.br/lava-e-seca-smart-lg-vc4-12kg-branca-com-inteligencia-artificial-aidd-cv5012wc4-220v-3410862/p"


  def start_link(params \\ %{}) do
    GenServer.start_link(__MODULE__, params, name: __MODULE__)
  end

  def init(initial_state) do
    {:ok, initial_state, {:continue, :init_state}}
  end

  def handle_continue(:init_state, state) do
    Process.send_after(self(), :inicializate, 1000)
    {:noreply, state}
  end

  def handle_info(:inicializate, state) do
    price = fetch_carrefour(@lava_e_seca)

    SCarrefour.insert_carrefour(%{name: "Lava e Seca Smart LG VC4 12kg Branca CV5012WC4", price: price, day: DateTime.utc_now()})

    timer = Process.send_after(self(), :inicializate, @verify)
    {:noreply, state |> Map.put(:timer, timer)}
  end


  def fetch_carrefour(url) do
    HTTPoison.get(url)
    |> parse_content()
    |> Floki.parse_document!()
    |> Floki.find("script[type=\"application/ld+json\"]")
    |> Enum.at(0)
    |> Tuple.to_list()
    |> Enum.at(2)
    |> Jason.decode!()
    |> Map.get("offers")
    |> Map.get("highPrice")
  end

  defp parse_content({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: body

  defp parse_content({:error, error}), do: error




end
