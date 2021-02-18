defmodule LiveChatApp.Utils do
  @moduledoc "Using a method more than once on different modules?
  put it here to practice DRY(Don't Repeat Yourself)"
  use Timex

  def format_date_time(datetime, format) when not is_nil(datetime) do
    datetime
    |> Timezone.convert(get_timezone(datetime))
    |> Timex.format(format, :strftime)
    |> elem(1)
  end

  def format_date_time(datetime, _), do: datetime

  defp get_timezone(datetime), do: Timex.Timezone.local(datetime)
end
