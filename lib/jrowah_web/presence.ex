defmodule JrowahWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See `Phoenix.Presence` for more information.
  """
  use Phoenix.Presence,
    otp_app: :jrowah,
    pubsub_server: Jrowah.PubSub
end
