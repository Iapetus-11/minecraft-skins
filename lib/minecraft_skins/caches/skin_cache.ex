defmodule MinecraftSkins.Caches.Skins do
  require Cachex.Spec

  def config do
    [
      name: :minecraft_skin_cache,
      limit: 100,
      expiration: Cachex.Spec.expiration(
        default: 30_000, interval: 15_000, lazy: true),
    ]
  end
end
