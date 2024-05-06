defmodule LineReminder.ReceiversFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LineReminder.Receivers` context.
  """

  alias LineReminder.Repo
  alias LineReminder.Receivers
  alias LineReminder.Notifiers.Receiver

  @doc """
  Generate a receiver.
  """
  def receiver_fixture(attrs \\ %{}) do
    {:ok, receiver} =
      attrs
      |> Enum.into(%{
        group: 1,
        token: "some token"
      })
      |> Receivers.create_receiver()

    receiver
  end

  @doc """
  Generate multiple receivers.
  """
  def multiple_receiver_fixture do
    receiver1 =
      Repo.insert!(%Receiver{
        token: "token1",
        group: :general,
        updated_at: ~U[2023-05-01 10:00:00Z]
      })

    receiver2 =
      Repo.insert!(%Receiver{
        token: "token2",
        group: :advanced,
        updated_at: ~U[2023-05-01 11:00:00Z]
      })

    receiver3 =
      Repo.insert!(%Receiver{
        token: "token3",
        group: :companion,
        updated_at: ~U[2023-05-01 12:00:00Z]
      })

    [receiver1, receiver2, receiver3]
  end
end
