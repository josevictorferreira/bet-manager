#!/bin/sh
mix deps.get
mix deps.compile
mix compile
mix ecto.setup
mix phx.server