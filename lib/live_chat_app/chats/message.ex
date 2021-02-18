defmodule LiveChatApp.Chats.Message do
  @moduledoc "Chats Message Schema"

  use Ecto.Schema
  import Ecto.Changeset

  alias LiveChatApp.Users.User
  alias LiveChatApp.Chats.Chat

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "messages" do
    field(:content, :string)
    field(:status, :string, default: "unread")

    belongs_to(:user, User)
    belongs_to(:chat, Chat, type: :binary_id)

    timestamps()
  end

  @optional ~w(status)a
  @required ~w(user_id chat_id content)a
  @statuses ~w(read unread)

  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
    |> validate_inclusion(:status, @statuses)
  end
end
