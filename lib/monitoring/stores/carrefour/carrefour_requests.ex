defmodule Monitoring.Stores.CarrefourRequests do
  def fetch(url) do
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
