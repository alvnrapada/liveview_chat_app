defmodule LiveChatApp.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveChatApp.Chats.Message
  alias LiveChatApp.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "chats" do
    field(:room_name, :string)

    belongs_to(:sender, User)
    belongs_to(:receiver, User)
    has_many(:messages, Message)

    timestamps()
  end

  @optional ~w(room_name)a
  @required ~w(sender_id receiver_id)a

  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
  end
end
