defmodule MinecraftSkinsWeb.Heads do
  use MinecraftSkinsWeb, :controller
  use Validation, [:validate_id]

  def validate_id(params) do
    {:id,
     cond do
       not Map.has_key?(params, "id") -> "This field is required"
       elem(UUID.info(params["id"]), 0) != :ok -> "This field requires a valid UUID"
       true -> :ok
     end}
  end

  def show(conn, params) do
    case validate(params) do
      :ok ->
        case Minecraft.Profile.get_or_fetch_user_profile(params["id"]) do
          :err ->
            put_status(conn, 404)
            json(conn, %{errors: %{id: "Unable to find Minecraft user for ID: #{params["id"]}"}})

          {:ok, profile} ->
            head_image =
              profile
              |> Minecraft.Profile.get_skin_texture_url()
              |> Minecraft.Skin.get_or_fetch_skin!()
              |> Image.from_binary!()
              |> Image.crop!(8, 8, 8, 8)

            image_data = Image.write!(head_image, :memory, suffix: ".webp")

            conn
            |> put_resp_content_type("image/webp")
            |> send_resp(200, image_data)
        end

      errors -> resp(conn, 400, Poison.encode!(errors))
    end
  end
end
