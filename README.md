# Minecraft Skin Renderer
*An Elixir/Phoenix microservice for rendering Minecraft skins (just heads for now). This is just a learning project.*

## Endpoints
### `GET /head/:id.:ext`
- Params:
    - `id` - A Minecraft player's UUID
    - `ext` - An image file extension, one of: `.png`, `.webp`, `.jpg`, `.jpeg`
        - Changing this controls the format the Head is serialized in
- Returns the 8x8 head from the specified Minecraft player's skin


## Setup
1. Install dependencies with `mix deps.get`
2. Run the server with `mix phx.server
