defmodule LineReminder.ReceiversTest do
  use LineReminder.DataCase

  import LineReminder.ReceiversFixtures

  alias LineReminder.Receivers
  alias LineReminder.Notifiers.Receiver

  describe "receivers" do
    @invalid_attrs %{group: nil, token: nil}
    @general 1
    @advacned 2

    test "list_receivers/0 returns all receivers" do
      receiver = receiver_fixture()
      assert Receivers.list_receivers() == [receiver]
    end

    test "get_receiver!/1 returns the receiver with given id" do
      receiver = receiver_fixture()
      assert Receivers.get_receiver!(receiver.id) == receiver
    end

    test "create_receiver/1 with valid data creates a receiver" do
      valid_attrs = %{group: @general, token: "some token"}

      assert {:ok, %Receiver{} = receiver} = Receivers.create_receiver(valid_attrs)
      assert receiver.group == :general
      assert receiver.token == "some token"
    end

    test "create_receiver/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Receivers.create_receiver(@invalid_attrs)
    end

    test "update_receiver/2 with valid data updates the receiver" do
      receiver = receiver_fixture()
      update_attrs = %{group: @advacned, token: "some updated token"}

      assert {:ok, %Receiver{} = receiver} = Receivers.update_receiver(receiver, update_attrs)
      assert receiver.group == :advanced
      assert receiver.token == "some updated token"
    end

    test "update_receiver/2 with invalid data returns error changeset" do
      receiver = receiver_fixture()
      assert {:error, %Ecto.Changeset{}} = Receivers.update_receiver(receiver, @invalid_attrs)
      assert receiver == Receivers.get_receiver!(receiver.id)
    end

    test "delete_receiver/1 deletes the receiver" do
      receiver = receiver_fixture()
      assert {:ok, %Receiver{}} = Receivers.delete_receiver(receiver)
      assert_raise Ecto.NoResultsError, fn -> Receivers.get_receiver!(receiver.id) end
    end

    test "change_receiver/1 returns a receiver changeset" do
      receiver = receiver_fixture()
      assert %Ecto.Changeset{} = Receivers.change_receiver(receiver)
    end
  end

  describe "update_receivers/1" do
    test "updates the updated_at field for the provided tokens" do
      receivers = multiple_receiver_fixture()
      tokens = Enum.map(receivers, & &1.token)
      before_update = Repo.all(Receiver)

      assert {3, nil} = Receivers.update_receivers(tokens)

      after_update = Repo.all(Receiver)

      updated_receivers =
        Enum.filter(after_update, &(&1.updated_at > List.first(before_update).updated_at))

      assert length(updated_receivers) == 3
    end

    test "returns {0, nil} when no receivers are found with the provided tokens" do
      assert {0, nil} = Receivers.update_receivers(["unknown_token"])
    end
  end
end
