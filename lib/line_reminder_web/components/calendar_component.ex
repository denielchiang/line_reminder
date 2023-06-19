defmodule LineReminderWeb.CalendarComponent do
  @moduledoc """
  Provides Calendar UI components.
  """
  use Phoenix.LiveComponent

  @week_start_at :monday

  def render(assigns) do
    ~H"""
    <div class="container mx-auto mt-10">
      <div class="wrapper bg-white rounded shadow w-full ">
        <div class="header flex justify-between border p-2">
          <span class="text-lg font-bold">
            <%= Calendar.strftime(@current_date, "%B %Y") %>
          </span>
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
                  <%= Calendar.strftime(week_day, "%A") %>
                </span>
                <span class="xl:hidden lg:hidden md:hidden sm:hidden block">
                  <%= Calendar.strftime(week_day, "%a") %>
                </span>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr :for={week <- @week_rows} class="text-center h-20">
              <td
                :for={day <- week}
                class={[
                  today?(day) && "bg-green-100",
                  other_month?(day, @current_date) && "bg-gray-100",
                  selected_date?(day, @selected_date) && "bg-blue-100",
                  "align-top border p-1 h-20 xl:w-20 lg:w-10 md:w-10 sm:w-20 w-10 overflow-auto transition cursor-pointer duration-500 ease hover:bg-gray-300"
                ]}
              >
                <div class="flex flex-col h-20 mx-auto xl:w-20 lg:w-20 md:w-20 sm:w-full w-10 mx-auto overflow-hidden">
                  <div class="bottom flex-grow h-10 py-1 w-full cursor-pointer">
                    <div class="event bg-blue-400 text-white rounded p-1 text-sm mb-1">
                      <span class="event-name">
                        馬太福音
                      </span>
                      <span class="time">
                        8
                      </span>
                    </div>
                  </div>
                </div>

                <button
                  type="button"
                  phx-target={@myself}
                  phx-click="pick-date"
                  phx-value-date={Calendar.strftime(day, "%Y-%m-%d")}
                >
                  <time datetime={Calendar.strftime(day, "%Y-%m-%d")}>
                    <%= Calendar.strftime(day, "%d") %>
                  </time>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  def mount(socket) do
    current_date = Date.utc_today()

    assigns = [
      current_date: current_date,
      selected_date: nil,
      week_rows: week_rows(current_date)
    ]

    {:ok, assign(socket, assigns)}
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
    |> Enum.map(& &1)
    |> Enum.chunk_every(7)
  end

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

  defp selected_date?(day, selected_date), do: day == selected_date

  defp today?(day), do: day == Date.utc_today()

  defp other_month?(day, current_date),
    do: Date.beginning_of_month(day) != Date.beginning_of_month(current_date)
end
