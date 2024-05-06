defmodule LineReminderWeb.HomeLive do
  use LineReminderWeb, :live_view

  alias LineReminderWeb.{HeroComponent, HomeComponent}

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:general_count, 100)
      |> assign(:advanced_count, 50)
      |> assign(:companion_count, 30)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.live_component
      module={HeroComponent}
      id="hero"
      general_count={@general_count}
      advanced_count={@advanced_count}
      companion_count={@companion_count}
    />
    <.live_component module={HomeComponent} id="home" />
    """
  end
end
