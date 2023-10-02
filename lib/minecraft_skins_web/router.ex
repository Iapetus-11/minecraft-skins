defmodule MinecraftSkinsWeb.Router do
  use MinecraftSkinsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MinecraftSkinsWeb do
    pipe_through :api

    get "/", Index, :show
    get "/head/:id_and_ext", Heads, :show
  end
end
