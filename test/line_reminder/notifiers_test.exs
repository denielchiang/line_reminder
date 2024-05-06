defmodule LineReminder.NotifiersTest do
  use LineReminder.DataCase

  import LineReminder.EventsFixtures

  alias LineReminder.Notifiers

  describe "get_events/1" do
    test "returns events grouped by group" do
      date = ~D[2023-05-06]

      events = [
        %{name: "Module1", group: :general, date: date},
        %{name: "Module2", group: :advanced, date: date},
        %{name: "Module3", group: :companion, date: date}
      ]

      event_fixture(events)

      expected_result = %{
        general: ["Module1"],
        advanced: ["Module2"],
        companion: ["Module3"]
      }

      assert Notifiers.get_events(date) == expected_result
    end
  end
end
