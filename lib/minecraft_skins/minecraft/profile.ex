defmodule Minecraft.Profile do
  @type minecraft_user_profile :: %{
    id: String.t,
    name: String.t,
    properties:
      list(%{
        name: String.t,
        value: String.t
      })
  }

  @spec fetch_user_profile(String.t) :: {:ok, minecraft_user_profile} | :err
  def fetch_user_profile(id) when is_binary(id) do
    HTTPoison.get("https://sessionserver.mojang.com/session/minecraft/profile/#{id}")
    |> then(
      &case &1 do
        {:ok, response} when response.status_code == 200 -> Poison.decode(response.body)
        _ -> :err
      end
    )
    |> then(
      &case &1 do
        {:ok, data} -> {:ok, data}
        _ -> :err
      end
    )
  end

  @spec get_or_fetch_user_profile(String.t) :: {:ok, minecraft_user_profile} | :err
  def get_or_fetch_user_profile(id) when is_binary(id) do
    case Cachex.get(:minecraft_profile_cache, id) do
      {:ok, res} when res != nil -> res

      _ ->
        profile = fetch_user_profile(id)
        Cachex.put!(:minecraft_profile_cache, id, profile)
        profile
    end
  end

  @spec get_decoded_profile_property(minecraft_user_profile, String.t) :: map
  def get_decoded_profile_property(profile, property) do
    profile["properties"]
    |> Enum.find(&(&1["name"] == property))
    |> then(&Base.decode64!(&1["value"]))
    |> Poison.decode!()
  end

  @spec get_skin_texture_url(minecraft_user_profile) :: String.t
  def get_skin_texture_url(profile) do
    get_decoded_profile_property(profile, "textures")["textures"]["SKIN"]["url"]
  end
end
