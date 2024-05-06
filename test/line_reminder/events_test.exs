defmodule LineReminder.EventsTest do
  use LineReminder.DataCase

  import LineReminder.EventsFixtures

  alias LineReminder.Events
  alias LineReminder.Notifiers.Event

  describe "events" do
    @invalid_attrs %{date: nil, name: nil, satus: nil}
    @general 1
    @advanced 2

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{date: ~D[2023-06-18], name: "some name", group: @general}

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.date == ~D[2023-06-18]
      assert event.name == "some name"
      assert event.group == :general
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()

      update_attrs = %{
        date: ~D[2023-06-19],
        name: "some updated name",
        group: @advanced
      }

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.date == ~D[2023-06-19]
      assert event.name == "some updated name"
      assert event.group == :advanced
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
