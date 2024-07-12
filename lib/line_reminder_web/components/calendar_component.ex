defmodule LineReminderWeb.CalendarComponent do
  @moduledoc """
  Provides Calendar UI components.
  """
  use Phoenix.LiveComponent

  import LineReminderWeb.Gettext, only: [gettext: 1]

  alias LineReminder.Notifiers.Receiver
  alias LineReminder.Notifiers
  alias LineReminder.DateHelper

  @week_start_at :sunday

  def render(assigns) do
    ~H"""
    <div class="container mx-auto mt-10">
      <div class="wrapper dark:bg-black bg-white rounded shadow w-full ">
        <div class="header flex justify-between border p-2">
          <span class="text-lg font-bold">
            <%= Calendar.strftime(@current_date, "%B %Y") %>
          </span>
          <div>
            <div class="badge badge-outline"><%= gettext("General") %></div>
            <div class="badge badge-primary badge-outline"><%= gettext("Advanced") %></div>
            <div class="badge badge-secondary badge-outline"><%= gettext("Companion") %></div>
            <div class="badge badge-accent badge-outline"><%= gettext("Companion2H") %></div>
          </div>
          <div class="buttons">
            <button type="button" phx-target={@myself} phx-click="prev-month" class="p-1">
              <svg
                width="1em"
                fill="gray"
                height="1em"
                viewBox="0 0 16 16"
                class="bi bi-arrow-left-circle"
                fill="currentColor"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  fill-rule="evenodd"
                  d="M8 15A7 7 0 1 0 8 1a7 7 0 0 0 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"
                />
                <path
                  fill-rule="evenodd"
                  d="M8.354 11.354a.5.5 0 0 0 0-.708L5.707 8l2.647-2.646a.5.5 0 1 0-.708-.708l-3 3a.5.5 0 0 0 0 .708l3 3a.5.5 0 0 0 .708 0z"
                />
                <path
                  fill-rule="evenodd"
                  d="M11.5 8a.5.5 0 0 0-.5-.5H6a.5.5 0 0 0 0 1h5a.5.5 0 0 0 .5-.5z"
                />
              </svg>
            </button>
            <button type="button" phx-target={@myself} phx-click="next-month" class="p-1">
              <svg
                width="1em"
                fill="gray"
                height="1em"
                viewBox="0 0 16 16"
                class="bi bi-arrow-right-circle"
                fill="currentColor"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  fill-rule="evenodd"
                  d="M8 15A7 7 0 1 0 8 1a7 7 0 0 0 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"
                />
                <path
                  fill-rule="evenodd"
                  d="M7.646 11.354a.5.5 0 0 1 0-.708L10.293 8 7.646 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0z"
                />
                <path
                  fill-rule="evenodd"
                  d="M4.5 8a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1H5a.5.5 0 0 1-.5-.5z"
                />
              </svg>
            </button>
          </div>
        </div>
        <table class="w-full">
          <thead>
            <tr>
              <th
                :for={week_day <- List.first(@week_rows)}
                class="p-2 border h-10 xl:w-40 lg:w-30 md:w-30 sm:w-20 w-10 xl:text-sm text-xs"
              >
                <span class="xl:block lg:block md:block sm:block hidden">
                  <%= Calendar.strftime(week_day.date, "%A") %>
                </span>
                <span class="xl:hidden lg:hidden md:hidden sm:hidden block">
                  <%= Calendar.strftime(week_day.date, "%a") %>
                </span>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr :for={week <- @week_rows} class="text-center h-40">
              <td
                :for={day <- week}
                class={[
                  other_month?(day.date, @current_date) && "dark:bg-gray-600 bg-gray-100",
                  selected_date?(day.date, @selected_date) && "bg-blue-100",
                  "align-top border p-1 h-30 xl:w-40 lg:w-20 md:w-20 sm:w-20 w-20 overflow-auto transition cursor-pointer duration-500 ease dark:hover:bg-gray-800 hover:bg-gray-100"
                ]}
              >
                <button
                  type="button"
                  phx-target={@myself}
                  phx-click="pick-date"
                  phx-value-date={Calendar.strftime(day.date, "%Y-%m-%d")}
                >
                  <time datetime={Calendar.strftime(day.date, "%Y-%m-%d")}>
                    <%= if today?(day.date) do %>
                      <div class="flex items-center justify-center w-8 h-8 bg-red-500 text-white text-lg font-bold rounded-full">
                        <%= Calendar.strftime(day.date, "%d") %>
                      </div>
                    <% else %>
                      <%= Calendar.strftime(day.date, "%d") %>
                    <% end %>
                  </time>
                </button>

                <div class={[
                  today?(day.date) && "dark:animate-bounce",
                  "flex flex-col h-full w-full overflow-hidden"
                ]}>
                  <div class="bottom flex-grow h-30 py-1 w-full cursor-pointer">
                    <!-- companion progress  -->
                    <p><.event_badge badge={day.event[:companion]} type={:companion} /></p>
                    <!-- general progress  -->
                    <p><.event_badge badge={day.event[:general]} type={:general} /></p>
                    <!-- advanced progress  -->
                    <p><.event_badge badge={day.event[:advanced]} type={:advanced} /></p>
                    <!-- companion2H progress  -->
                    <p><.event_badge badge={day.event[:companion2H]} type={:companion2H} /></p>
                  </div>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  def mount(socket) do
    with current_date <- DateHelper.taiwan_today() do
      assigns = [
        current_date: current_date,
        selected_date: nil,
        week_rows: week_rows(current_date)
      ]

      {:ok, assign(socket, assigns)}
    end
  end

  def event_badge(%{badge: event} = assigns) when is_nil(event) do
    ~H"""
    <!-- No event -->
    """
  end

  def event_badge(%{type: :general} = assigns) do
    ~H"""
    <div class="badge badge-outline"><%= List.to_string(assigns[:badge]) %></div>
    """
  end

  def event_badge(%{type: :advanced} = assigns) do
    ~H"""
    <%= for ch <- maybe_multi_chps(assigns[:badge]) do %>
      <div class="badge badge-primary badge-outline"><%= ch %></div>
    <% end %>
    """
  end

  def event_badge(%{type: :companion} = assigns) do
    ~H"""
    <%= for ch <- maybe_multi_chps(assigns[:badge]) do %>
      <div class="badge badge-secondary badge-outline"><%= ch %></div>
    <% end %>
    """
  end

  def event_badge(%{type: :companion2H} = assigns) do
    ~H"""
    <%= for ch <- maybe_multi_chps(assigns[:badge]) do %>
      <div class="badge badge-accent badge-outline"><%= ch %></div>
    <% end %>
    """
  end

  defp week_rows(current_date) do
    first =
      current_date
      |> Date.beginning_of_month()
      |> Date.beginning_of_week(@week_start_at)

    last =
      current_date
      |> Date.end_of_month()
      |> Date.end_of_week(@week_start_at)

    Date.range(first, last)
    |> Enum.map(&maybe_event_day(&1))
    |> Enum.chunk_every(7)
  end

  defp maybe_event_day(date) do
    date
    |> Notifiers.get_events()
    |> wrapping_result(date)
  end

  defp wrapping_result(event, date), do: %{date: date, event: event}

  def handle_event("prev-month", _, socket) do
    new_date = socket.assigns.current_date |> Date.beginning_of_month() |> Date.add(-1)

    assigns = [
      current_date: new_date,
      week_rows: week_rows(new_date)
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("next-month", _, socket) do
    new_date = socket.assigns.current_date |> Date.end_of_month() |> Date.add(1)

    assigns = [
      current_date: new_date,
      week_rows: week_rows(new_date)
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("pick-date", %{"date" => date}, socket) do
    {:noreply, assign(socket, :selected_date, Date.from_iso8601!(date))}
  end

  def handle_info({:updated, %Receiver{group: group}}, socket) do
    {:noreply, assign(socket, group: group, count: count_subscribers(group))}
  end

  defp count_subscribers(group) do
    IO.inspect(group, label: "##########")
    1
  end

  defp selected_date?(day, selected_date), do: day == selected_date

  defp today?(day), do: day == DateHelper.taiwan_today()

  defp other_month?(day, current_date),
    do: Date.beginning_of_month(day) != Date.beginning_of_month(current_date)

  defp maybe_multi_chps(event), do: List.to_string(event) |> String.split(";")
end
