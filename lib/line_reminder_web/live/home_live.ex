defmodule LineReminderWeb.HomeLive do
  use LineReminderWeb, :live_view

  alias LineReminderWeb.{HeroComponent, HomeComponent}

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:count, 10)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.live_component module={HeroComponent} id="hero" count={@count} />
    <.live_component module={HomeComponent} id="home" />
    """
  end
end
