defmodule LineReminderWeb.HomeLive do
  use LineReminderWeb, :live_view

  alias LineReminder.Receivers
  alias LineReminderWeb.HeroComponent
  alias LineReminderWeb.HomeComponent

  def mount(_params, _session, socket) do
    %{general: g_cnt, advanced: a_cnt, companion: c_cnt, companion2h: c2h_cnt} =
      Receivers.count_receiver_groups()

    socket =
      socket
      |> assign(:general_count, g_cnt)
      |> assign(:advanced_count, a_cnt)
      |> assign(:companion_count, c_cnt)
      |> assign(:companion2h_count, c2h_cnt)

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
      companion2h_count={@companion2h_count}
    />
    <.live_component module={HomeComponent} id="home" />
    """
  end
end
