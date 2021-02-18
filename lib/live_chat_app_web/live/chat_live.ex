defmodule LiveChatAppWeb.ChatLive do
  use LiveChatAppWeb, :live_view

  # Function Aliases
  alias LiveChatApp.Chats
  alias LiveChatAppWeb.LiveViewCredentials

  def mount(_params, session, socket) do
    with current_user <- LiveViewCredentials.get_user(socket, session),
         _sessions <- create_chat_from_users(current_user),
         topics <- Chats.get_topics(current_user) do
      IO.inspect(topics)
      if connected?(socket), do: Chats.subscribe()

      socket =
        assign(socket,
          current_user: current_user,
          topics: topics,
          selected_topic: nil,
          sending: false,
          topic_messages: [],
          search_value: nil
        )

      {:ok, socket}
    end
  end

  def render(assigns) do
    Phoenix.View.render(LiveChatAppWeb.ChatView, "chat_index.html", assigns)
  end

  def handle_params(%{"topic" => topic_id}, _url, socket) do
    with %{current_user: current_user, search_value: search_value} <- socket.assigns,
         selected_topic when not is_nil(selected_topic) <- Chats.get(topic_id),
         _ <- Chats.read_messages(selected_topic),
         topics <- Chats.search_topics(current_user, search_value) do
      socket =
        assign(socket,
          topics: topics,
          selected_topic: selected_topic,
          topic_messages: selected_topic.messages
        )

      {:noreply, socket}
    else
      _ ->
        {:noreply, socket}
    end
  end

  def handle_params(_, _url, socket) do
    with %{topics: topics} <- socket.assigns do
      case topics do
        [] ->
          {:noreply, socket}

        topics ->
          selected_topic = topics |> List.first()

          socket =
            push_patch(socket,
              to:
                Routes.live_path(
                  socket,
                  __MODULE__,
                  topic: selected_topic.id
                )
            )

          {:noreply, socket}
      end
    end
  end

  def handle_event("send_message", params, socket) do
    with %{current_user: current_user, selected_topic: selected_topic} <- socket.assigns,
         params <- parse_params(params, current_user.id, selected_topic.id) do
      socket =
        assign(socket,
          sending: true
        )

      send(self(), {:run_send_message, params})

      {:noreply, socket}
    end
  end

  # Search Topic -> Start

  def handle_event("search_topic", %{"search_value" => value}, socket) do
    socket =
      assign(socket,
        search_value: value
      )

    send(self(), {:run_search, value})

    {:noreply, socket}
  end

  def handle_info({:run_search, value}, socket) do
    with %{current_user: current_user} <- socket.assigns,
         topics <- Chats.search_topics(current_user, value) do
      socket =
        assign(socket,
          topics: topics
        )

      {:noreply, socket}
    end
  end

  # Search Topic <- End

  def handle_info({:run_send_message, params}, socket) do
    case Chats.create_message(params) do
      {:ok, _} ->
        socket =
          assign(socket,
            sending: false
          )

        {:noreply, socket}

      _ ->
        socket =
          assign(socket,
            sending: false
          )

        {:noreply, socket}
    end
  end

  def handle_info({:message_created, message}, socket) do
    with %{
           selected_topic: st,
           current_user: current_user,
           topic_messages: topic_messages,
           search_value: search_value
         } <- socket.assigns do
      case message.user_id == st.sender_id or message.user_id == st.receiver_id do
        true ->
          topics = Chats.search_topics(current_user, search_value)

          socket =
            assign(socket,
              topics: topics
            )

          socket =
            assign(socket,
              topic_messages: topic_messages ++ [message]
            )

          {:noreply, socket}

        _ ->
          topic = Chats.get(message.chat_id)

          case current_user.id == topic.sender_id or current_user.id == topic.receiver_id do
            true ->
              topics = Chats.search_topics(current_user, search_value)

              socket =
                assign(socket,
                  topics: topics
                )

              {:noreply, socket}

            _ ->
              {:noreply, socket}
          end
      end
    end
  end

  # Private
  defp create_chat_from_users(current_user) when is_struct(current_user) do
    users = Chats.get_users(current_user)
    existing_topics = Chats.get_topics(current_user)

    users
    |> Enum.map(fn f ->
      case Enum.find(
             existing_topics,
             &(f.id == &1.sender_id or f.id == &1.receiver_id)
           ) do
        nil -> Chats.create_chat(%{sender_id: current_user.id, receiver_id: f.id})
        topic -> {:ok, topic}
      end
    end)
  end

  defp create_chat_from_users(_), do: {:ok, []}

  defp parse_params(params, user_id, chat_id) do
    params
    |> Map.put("user_id", user_id)
    |> Map.put("chat_id", chat_id)
  end
end
