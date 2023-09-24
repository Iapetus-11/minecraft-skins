defmodule MinecraftSkins.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Cachex.Spec

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MinecraftSkinsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MinecraftSkins.PubSub},
      # Start the Endpoint (http/https)
      MinecraftSkinsWeb.Endpoint,
      # Start a worker by calling: MinecraftSkins.Worker.start_link(arg)
      # {MinecraftSkins.Worker, arg}

      # Caches
      Supervisor.child_spec({Cachex, MinecraftSkins.Caches.Profiles.config()}, id: :cachex_minecraft_profiles),
      Supervisor.child_spec({Cachex, MinecraftSkins.Caches.Skins.config()}, id: :cachex_minecraft_skins),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MinecraftSkins.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  @spec config_change(any, any, any) :: :ok
  def config_change(changed, _new, removed) do
    MinecraftSkinsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
