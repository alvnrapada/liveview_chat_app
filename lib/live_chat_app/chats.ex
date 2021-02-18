defmodule LiveChatApp.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias LiveChatApp.Repo

  alias LiveChatApp.Users.User

  alias LiveChatApp.Chats.{
    Chat,
    Message
  }

  def subscribe, do: Phoenix.PubSub.subscribe(LiveChatApp.PubSub, "chats")

  def get_topics(%User{id: user_id}) do
    Chat
    |> where([c], c.sender_id == ^user_id or c.receiver_id == ^user_id)
    |> preload(^preloads())
    |> Repo.all()
  end

  def get_topics(_), do: []

  def get(id) when is_binary(id) do
    Chat
    |> preload(^preloads())
    |> Repo.get(id)
  end

  def get_users(%User{id: id}) do
    User
    |> where([u], u.id != ^id)
    |> Repo.all()
  end

  def get_users(_), do: []

  def create_chat(params) do
    %Chat{}
    |> Chat.changeset(params)
    |> Repo.insert()
  end

  def search_topics(current_user, value) when not is_nil(value) and value !== "" do
    topics = get_topics(current_user)

    topics
    |> Enum.filter(fn %{sender: sender, receiver: receiver} ->
      case sender.id == current_user.id do
        true ->
          string_starts_with?(receiver.email, value)

        _ ->
          string_starts_with?(sender.email, value)
      end
    end)
  end

  def search_topics(current_user, _), do: get_topics(current_user)

  # Messages
  def create_message(params) do
    %Message{}
    |> Message.changeset(params)
    |> Repo.insert()
    |> broadcast(:message_created)
  end

  # read_message/1 : when user opens a conversation, we need to
  # update all unread messages to unread
  def read_messages(%Chat{id: chat_id}) do
    Message
    |> where([m], m.chat_id == ^chat_id and m.status == "unread")
    |> Repo.update_all(set: [status: "read"])
  end

  def read_messages(_chat), do: :ok

  def broadcast({:ok, message}, event) do
    Phoenix.PubSub.broadcast(
      LiveChatApp.PubSub,
      "chats",
      {event, Repo.preload(message, :user)}
    )

    {:ok, message}
  end

  def broadcast({:error, _reason} = error, _event), do: error

  # Private Methods
  defp string_starts_with?(string, value),
    do: String.starts_with?(String.downcase(string), String.downcase(value))

  defp preloads do
    [:sender, :receiver, messages: :user]
  end
end
