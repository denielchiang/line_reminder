defmodule LineReminderWeb.HomeComponent do
  @moduledoc """
  Provides Hero UI components.
  """
  use Phoenix.LiveComponent

  import LineReminderWeb.Gettext, only: [gettext: 1]

  alias LineReminder.QrcodeHelper

  def render(assigns) do
    ~H"""
    <div class="relative isolate overflow-hidden bg-white px-6 py-24 sm:py-32 lg:overflow-visible lg:px-0">
      <div class="absolute inset-0 -z-10 overflow-hidden">
        <svg
          class="absolute left-[max(50%,25rem)] top-0 h-[64rem] w-[128rem] -translate-x-1/2 stroke-gray-200 [mask-image:radial-gradient(64rem_64rem_at_top,white,transparent)]"
          aria-hidden="true"
        >
          <defs>
            <pattern
              id="e813992c-7d03-4cc4-a2bd-151760b470a0"
              width="200"
              height="200"
              x="50%"
              y="-1"
              patternUnits="userSpaceOnUse"
            >
              <path d="M100 200V.5M.5 .5H200" fill="none" />
            </pattern>
          </defs>
          <svg x="50%" y="-1" class="overflow-visible fill-gray-50">
            <path
              d="M-100.5 0h201v201h-201Z M699.5 0h201v201h-201Z M499.5 400h201v201h-201Z M-300.5 600h201v201h-201Z"
              stroke-width="0"
            />
          </svg>
          <rect
            width="100%"
            height="100%"
            stroke-width="0"
            fill="url(#e813992c-7d03-4cc4-a2bd-151760b470a0)"
          />
        </svg>
      </div>
      <div class="mx-auto grid max-w-2xl grid-cols-1 gap-x-8 gap-y-16 lg:mx-0 lg:max-w-none lg:grid-cols-2 lg:items-start lg:gap-y-10">
        <div class="lg:col-span-2 lg:col-start-1 lg:row-start-1 lg:mx-auto lg:grid lg:w-full lg:max-w-7xl lg:grid-cols-2 lg:gap-x-8 lg:px-8">
          <div class="lg:pr-4">
            <div class="lg:max-w-lg">
              <p class="text-base font-semibold leading-7 text-indigo-600">
                <%= gettext("Notify your progress") %>
              </p>
              <h1 class="mt-2 text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
                <%= gettext("Introduction to Line Notify Integration") %>
              </h1>
              <p class="mt-6 text-xl leading-8 text-gray-700">
                <%= gettext(
                  "Welcome to our platform! To receive timely updates on your Bible reading progress, follow these simple steps using Line Notify Bot"
                ) %>
              </p>
            </div>
          </div>
        </div>
        <div class="flex-1 -ml-12 -mt-8 p-8 sticky lg:top-1 lg:col-start-2 lg:row-span-2 lg:row-start-1 lg:overflow-hidden ">
          <div class="carousel carousel-center max-w-md p-4 space-x-4 rounded-box">
            <%= for {lead, {qr_image, qr_url}} <- @qrcodes do %>
              <div class="carousel-item">
                <div class="mockup-phone shadow-lg">
                  <div class="camera"></div>
                  <div class="display">
                    <div class="artboard artboard-demo phone-1">
                      <img src={qr_image} class="rounded-box w-5/6 bg-gray-900" alt={lead} />
                      <lead><a href={qr_url}><%= lead %></a></lead>
                    </div>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        </div>
        <div class="lg:col-span-2 lg:col-start-1 lg:row-start-2 lg:mx-auto lg:grid lg:w-full lg:max-w-7xl lg:grid-cols-2 lg:gap-x-8 lg:px-8">
          <div class="lg:pr-4">
            <div class="text-center">
              <p class="mt-4 text-sm leading-7 text-gray-500 font-regular">
                <%= gettext("STEPS") %>
              </p>
              <h3 class="text-3xl sm:text-5xl leading-normal font-extrabold tracking-tight text-gray-900">
                <%= gettext("How it") %> <span class="text-indigo-600"><%= gettext("Works?") %></span>
              </h3>
            </div>
            <div class="mt-20">
              <ul class="">
                <li class="text-left mb-10">
                  <div class="flex flex-row items-start">
                    <div class="flex flex-col items-center justify-center mr-5">
                      <div class="flex items-center justify-center h-20 w-20 rounded-full bg-indigo-600 text-white border-4 border-white text-xl font-semibold">
                        1
                      </div>
                      <span class="text-gray-500"><%= gettext("STEP") %></span>
                    </div>
                    <div class="bg-gray-100 p-5 pb-10 ">
                      <h4 class="text-lg leading-6 font-semibold text-gray-900">
                        <%= gettext("Choose a Program") %>
                      </h4>
                      <p class="mt-2 text-base leading-6 text-gray-500">
                        <%= gettext(
                          "Scan one of the three QR codes corresponding to \"General Program,\" \"Companion Program,\" or \"Advanced Program\" to begin."
                        ) %>
                      </p>
                    </div>
                  </div>
                </li>
                <li class="text-left mb-10">
                  <div class="flex flex-row items-start">
                    <div class="flex flex-col items-center justify-center mr-5">
                      <div class="flex items-center justify-center h-20 w-20 rounded-full bg-indigo-600 text-white border-4 border-white text-xl font-semibold">
                        2
                      </div>
                      <span class="text-gray-500"><%= gettext("STEP") %></span>
                    </div>
                    <div class="bg-gray-100 p-5 pb-10">
                      <h4 class="text-lg leading-6 font-semibold text-gray-900">
                        <%= gettext("Select Line Chat") %>
                      </h4>
                      <p class="mt-2 text-base leading-6 text-gray-500">
                        <%= gettext(
                          "After scanning, select the Line chat where you want to receive daily reminders. Remember to invite the Line Notifier Bot to this chat first."
                        ) %>
                      </p>
                    </div>
                  </div>
                </li>
                <li class="text-left mb-10">
                  <div class="flex flex-row items-start">
                    <div class="flex flex-col items-center justify-center mr-5">
                      <div class="flex items-center justify-center h-20 w-20 rounded-full bg-indigo-600 text-white border-4 border-white text-xl font-semibold">
                        3
                      </div>
                      <span class="text-gray-500"><%= gettext("STEP") %></span>
                    </div>
                    <div class="bg-gray-100 p-5 pb-10 ">
                      <h4 class="text-lg leading-6 font-semibold text-gray-900">
                        <%= gettext("Subscribe Confirmation") %>
                      </h4>
                      <p class="mt-2 text-base leading-6 text-gray-500">
                        <%= gettext(
                          "Upon successful subscription, expect a message like \"You have subscribed to the General Reading Progress Assistant 🚀\" from the Line Notifier Bot."
                        ) %>
                      </p>
                    </div>
                  </div>
                </li>
                <li class="text-left mb-10">
                  <div class="flex flex-row items-start">
                    <div class="flex flex-col items-center justify-center mr-5">
                      <div class="flex items-center justify-center h-20 w-20 rounded-full bg-indigo-600 text-white border-4 border-white text-xl font-semibold">
                        4
                      </div>
                      <span class="text-gray-500"><%= gettext("STEP") %></span>
                    </div>
                    <div class="bg-gray-100 p-5 pb-10 ">
                      <h4 class="text-lg leading-6 font-semibold text-gray-900">
                        <%= gettext("Receive Notifications") %>
                      </h4>
                      <p class="mt-2 text-base leading-6 text-gray-500">
                        <%= gettext(
                          "You'll start receiving daily notifications in your Line chat at 6 am."
                        ) %>
                      </p>
                    </div>
                  </div>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def mount(socket) do
    qrcodes = QrcodeHelper.gen_qrcodes() |> Enum.map(fn {:ok, qrcode_info} -> qrcode_info end)
    groups = QrcodeHelper.get_groups() |> Enum.map(&append_wording/1)
    qrcode_map = Enum.zip(groups, qrcodes) |> Map.new() |> Enum.reverse()

    {:ok,
     socket
     |> assign(:qrcodes, qrcode_map)}
  end

  defp append_wording("general"), do: gettext("General Program")
  defp append_wording("advanced"), do: gettext("Advanced Program")
  defp append_wording("companion"), do: gettext("Companion Program")
  defp append_wording("companion2h"), do: gettext("Companion 2nd Half Program")
  defp append_wording(word), do: IO.puts(word)
end
