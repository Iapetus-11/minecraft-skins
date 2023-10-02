defmodule MinecraftSkinsWeb.Index do
  use MinecraftSkinsWeb, :controller

  def show(conn, _params) do
    json conn, %{
      repository_and_docs: "https://github.com/Iapetus-11/minecraft-skins",
    }
  end
end
