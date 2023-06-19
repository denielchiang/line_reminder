defmodule LineReminderWeb.ScheduleLive do
  use LineReminderWeb, :live_view

  alias LineReminderWeb.CalendarComponent

  def mount(_params, _session, socket) do
    socket = assign(socket, :count, 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.live_component module={CalendarComponent} id="calendar" />
    """
  end
end
