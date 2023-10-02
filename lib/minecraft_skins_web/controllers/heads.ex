defmodule MinecraftSkinsWeb.Heads do
  use MinecraftSkinsWeb, :controller
  use Validation, [:validate_id_and_ext]

  @valid_image_extensions MapSet.new(["png", "webp", "jpg", "jpeg"])

  def validate_id_and_ext(params) do
    {:id_and_ext,
     cond do
       not Map.has_key?(params, "id_and_ext") -> "Invalid route, expected something like: cbcfa252867d4bdaa214776c881cf370.webp"
      true ->
        split_id_and_ext = String.split(params["id_and_ext"], ".")

        case split_id_and_ext do
          _ when length(split_id_and_ext) == 1 -> "Invalid route, missing file extension (like .webp or .png)"
          _ when length(split_id_and_ext) != 2 -> "Invalid route, expected something like: cbcfa252867d4bdaa214776c881cf370.webp"
          [id, ext] ->
            cond do
              elem(UUID.info(id), 0) != :ok -> "The route part before the file extension must be a valid UUID"
              not MapSet.member?(@valid_image_extensions, ext) -> "The file extension at the end must be one of: #{Enum.join(@valid_image_extensions, ", ")}"
              true -> :ok
            end
        end
     end}
  end

  @spec parse_id_and_ext(map) :: {String.t(), String.t()}
  def parse_id_and_ext(params) do
    params["id_and_ext"]
    |> String.split(".")
    |> List.to_tuple()
  end

  def show(conn, params) do
    case validate(params) do
      :ok ->
        {id, image_extension} = parse_id_and_ext(params)
        case Minecraft.Profile.get_or_fetch_user_profile(id) do
          :err ->
            put_status(conn, 404)
            json(conn, %{errors: %{id: "Unable to find Minecraft user for ID: #{id}"}})

          {:ok, profile} ->
            head_image =
              profile
              |> Minecraft.Profile.get_skin_texture_url()
              |> Minecraft.Skin.get_or_fetch_skin!()
              |> Image.from_binary!()
              |> Image.crop!(8, 8, 8, 8)

            image_data = Image.write!(head_image, :memory, suffix: "." <> image_extension)

            conn
            |> put_resp_content_type("image/" <> image_extension)
            |> send_resp(200, image_data)
        end

      errors -> resp(conn, 400, Poison.encode!(errors))
    end
  end
end
