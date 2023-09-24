defmodule MinecraftSkins.Caches.Profiles do
  require Cachex.Spec

  def config do
    [
      name: :minecraft_profile_cache,
      limit: 1000,
      expiration: Cachex.Spec.expiration(
        default: 60_000,
        interval: 30_000,
        lazy: true
      )
    ]
  end
end
