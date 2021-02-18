defmodule LiveChatAppWeb.LiveViewCredentials do
  # Code Source: https://github.com/danschultzer/pow/issues/271#issuecomment-621526126

  @moduledoc "Authentication helper functions"

  alias LiveChatApp.Users.User
  alias Phoenix.LiveView.Socket
  alias Pow.Store.CredentialsCache

  @doc """
  Retrieves the currently-logged-in user from the Pow credentials cache.
  """
  @spec get_user(
          socket :: Socket.t(),
          session :: map(),
          config :: keyword()
        ) :: %User{} | nil

  def get_user(socket, session, config \\ [otp_app: :myapp])

  # core_blayze_app_auth
  def get_user(socket, %{"live_chat_app_auth" => signed_token}, config) do
    conn = struct!(Plug.Conn, secret_key_base: socket.endpoint.config(:secret_key_base))
    salt = Atom.to_string(Pow.Plug.Session)

    with {:ok, token} <- Pow.Plug.verify_token(conn, salt, signed_token, config),
         {user, _metadata} <- CredentialsCache.get([backend: Pow.Store.Backend.EtsCache], token) do
      user
    else
      _any -> nil
    end
  end

  def get_user(_, _, _), do: nil
end
