defmodule LineReminder.RemindersTest do
  use LineReminder.DataCase

  alias LineReminder.Reminders

  describe "events" do
    alias LineReminder.Reminders.Event

    import LineReminder.RemindersFixtures

    @invalid_attrs %{date: nil, name: nil, satus: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Reminders.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Reminders.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{date: ~D[2023-06-18], name: "some name", satus: "some satus"}

      assert {:ok, %Event{} = event} = Reminders.create_event(valid_attrs)
      assert event.date == ~D[2023-06-18]
      assert event.name == "some name"
      assert event.satus == "some satus"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reminders.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        date: ~D[2023-06-19],
        name: "some updated name",
        satus: "some updated satus"
      }

      assert {:ok, %Event{} = event} = Reminders.update_event(event, update_attrs)
      assert event.date == ~D[2023-06-19]
      assert event.name == "some updated name"
      assert event.satus == "some updated satus"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Reminders.update_event(event, @invalid_attrs)
      assert event == Reminders.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Reminders.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Reminders.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Reminders.change_event(event)
    end
  end
end
