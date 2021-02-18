defmodule LiveChatApp.Repo do
  use Ecto.Repo,
    otp_app: :live_chat_app,
    adapter: Ecto.Adapters.Postgres
end
