defmodule LiveChatAppWeb.ChatView do
  use LiveChatAppWeb, :view
  alias LiveChatApp.Utils

  def parse_topic_info(topic, current_user) do
    %{
      profile_picture: parse_dp(topic, current_user.id),
      from: parse_from(topic, current_user.id),
      unread_count: unread_count(topic.messages, current_user.id),
      latest_message: get_latest_message(topic.messages, current_user.id),
      time: Utils.format_date_time(topic.inserted_at, "%m/%d/%y")
    }
  end

  def parse_from(nil, _current_user_id), do: "Anonymous User"

  def parse_from(topic, current_user_id) do
    case topic.sender_id == current_user_id do
      true ->
        parse_name(topic.receiver)

      _ ->
        parse_name(topic.sender)
    end
  end

  def parse_name(user) when is_struct(user),
    do: user.email

  def parse_name(_user), do: "Anonymous User"

  def group_messages(data) when is_list(data) do
    data
    |> Enum.map(fn f ->
      f
      |> Map.put(:date, Utils.format_date_time(f.inserted_at, "%b %d, %Y"))
    end)
    |> Enum.group_by(& &1.date)
  end

  def sort_messages(data) when is_list(data) do
    data
    |> Enum.filter(&(not is_nil(&1.inserted_at)))
    |> Enum.sort_by(& &1.inserted_at, {:asc, NaiveDateTime})
  end

  @default_dp "https://avatars.githubusercontent.com/u/62341430?s=60&v=4"
  def get_dp(%{profile_picture: pp}) when not is_nil(pp), do: pp
  def get_dp(_user), do: @default_dp

  # Private Methods

  defp unread_count(messages, current_user_id) do
    messages
    |> Enum.filter(&(&1.status == "unread" and &1.user_id !== current_user_id))
    |> Enum.count()
  end

  defp get_latest_message([], _current_user_id), do: %{}

  defp get_latest_message(messages, current_user_id) do
    with message <-
           messages
           |> Enum.sort_by(& &1.inserted_at, {:desc, NaiveDateTime})
           |> List.first() do
      data =
        "#{if message.user_id == current_user_id, do: "You", else: parse_name(message.user)} : #{
          message.content
        }"

      %{
        message: "#{String.slice(data, 0..25)}...",
        time: message.inserted_at |> Timex.format("{relative}", :relative) |> elem(1)
      }
    end
  end

  defp parse_dp(nil, _current_user_id), do: @default_dp

  defp parse_dp(topic, current_user_id) do
    case topic.sender_id == current_user_id do
      true ->
        get_dp(topic.receiver)

      _ ->
        get_dp(topic.sender)
    end
  end

  def get(map, fields) when is_list(fields),
    do: Enum.reduce(fields, map, fn field, map -> if map, do: Map.get(map, field) end)
end
