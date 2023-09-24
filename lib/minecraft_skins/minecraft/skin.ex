defmodule Minecraft.Skin do
  @spec fetch_skin(String.t()) :: {:ok, binary} | :err
  def fetch_skin(url) when is_binary(url) do
    HTTPoison.get(url)
    |> then(
      &case &1 do
        {:ok, res} -> {:ok, res.body}
        _ -> :err
      end
    )
  end

  @spec fetch_skin!(String.t) :: binary
  def fetch_skin!(url) when is_binary(url) do
    case fetch_skin(url) do
      {:ok, data} -> data
      _ -> raise "Unable to fetch skin"
    end
  end

  def get_or_fetch_skin!(url) when is_binary(url) do
    case Cachex.get(:minecraft_skin_cache, url) do
      {:ok, res} when res != nil -> res

      _ ->
        image = fetch_skin!(url)
        Cachex.put!(:minecraft_skin_cache, url, image)
        image
    end
  end
end
