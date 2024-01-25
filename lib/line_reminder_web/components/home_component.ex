defmodule LineReminderWeb.HomeComponent do
  @moduledoc """
  Provides Hero UI components.
  """
  use Phoenix.LiveComponent

  import LineReminderWeb.Gettext, only: [gettext: 1]

  def mount(socket, assigns) do
    {:ok, assign(socket, assigns)}
  end

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
                <%= gettext("Notify progress") %>
              </p>
              <h1 class="mt-2 text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
                <%= gettext("Introduction to Line Notify Integration") %>
              </h1>
              <p class="mt-6 text-xl leading-8 text-gray-700">
                <%= gettext(
                  "Welcome to our platform! To receive timely updates on your Bible reading progress, follow these simple steps using Line Notify:"
                ) %>
              </p>
            </div>
          </div>
        </div>
        <div class="flex-1 -ml-12 -mt-12 p-12 lg:sticky lg:top-4 lg:col-start-2 lg:row-span-2 lg:row-start-1 lg:overflow-hidden">
          <img class="w-full bg-gray-900" src="/images/general.svg" alt="" />
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
                        <%= gettext("Select Your Notification Group") %>
                      </h4>
                      <p class="mt-2 text-base leading-6 text-gray-500">
                        <%= gettext(
                          "On the right, you will find three QR codes representing different notification groups. Choose the group you wish to receive updates from."
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
                    <div class="bg-gray-100 p-5 pb-10 ">
                      <h4 class="text-lg leading-6 font-semibold text-gray-900">
                        <%= gettext("Login to Line and Choose Your Group") %>
                      </h4>
                      <p class="mt-2 text-base leading-6 text-gray-500">
                        <%= gettext(
                          "After selecting a group, log in to your Line account. Choose the specific group within Line where you'd like to receive notifications."
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
                        <%= gettext("Subscription Confirmation") %>
                      </h4>
                      <p class="mt-2 text-base leading-6 text-gray-500">
                        <%= gettext(
                          "Once selected, you will receive a confirmation message in the chosen group, such as \"You have subscribed to the General Reading Progress Assistant 🚀.\" This confirms your subscription."
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
                        <%= gettext("Receive Daily Progress Reminders") %>
                      </h4>
                      <p class="mt-2 text-base leading-6 text-gray-500">
                        <%= gettext(
                          "Starting from the next day, you will receive progress reminders at 6 AM. These messages will keep you updated on your Bible reading journey."
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
end
