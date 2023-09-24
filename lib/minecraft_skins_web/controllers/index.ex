defmodule MinecraftSkinsWeb.Index do
  use MinecraftSkinsWeb, :controller

  def show(conn, _params) do
    json conn, %{
      author: "https://github.com/Iapetus-11",
    }
  end
end
