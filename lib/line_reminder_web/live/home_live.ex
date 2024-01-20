defmodule LineReminderWeb.HomeLive do
  use LineReminderWeb, :live_view

  alias LineReminderWeb.{HeroComponent, HomeComponent}

  def mount(_params, _session, socket) do
    socket = assign(socket, :count, 10)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.live_component module={HeroComponent} id="hero" />
    <.live_component module={HomeComponent} id="home" />
    """
  end
end
