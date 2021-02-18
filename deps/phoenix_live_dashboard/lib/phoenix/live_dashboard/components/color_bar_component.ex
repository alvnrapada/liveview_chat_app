defmodule Phoenix.LiveDashboard.ColorBarComponent do
  use Phoenix.LiveDashboard.Web, :live_component

  def mount(socket) do
    {:ok, assign(socket, :title, nil)}
  end

  def render(assigns) do
    ~L"""
    <div class="progress flex-grow-1 mb-3">
      <span class="progress-title"><%= @title %></span>
      <%= for {{name, value, color, _desc}, index} <- Enum.with_index(@data) do %>
        <style nonce="<%= @csp_nonces.style %>">#<%= "#{@dom_id}-progress-#{index}" %>{width:<%= value %>%}</style>
        <div
        title="<%= name %> - <%= format_percent(value) %>"
        class="progress-bar bg-gradient-<%= color %>"
        role="progressbar"
        aria-valuenow="<%= maybe_round(value) %>"
        aria-valuemin="0"
        aria-valuemax="100"
        data-name="<%= name %>"
        data-empty="<%= empty?(value) %>"
        id="<%= "#{@dom_id}-progress-#{index}" %>">
        </div>
      <% end %>
    </div>
    """
  end

  defp maybe_round(num) when is_integer(num), do: num
  defp maybe_round(num), do: Float.ceil(num, 1)

  defp empty?(value) when is_number(value) and value > 0, do: false
  defp empty?(_), do: true
end
