defmodule LineReminder.Receivers do
  @moduledoc """
  The Receivers context.
  """

  import Ecto.Query, warn: false

  alias LineReminder.Repo
  alias LineReminder.Notifiers.Receiver

  @type receiver :: %LineReminder.Notifiers.Receiver{}

  @general_code 1
  @advanced_code 2
  @companion_code 3
  @companion2H_code 4

  @doc """
  Reture corresponding prgoram code in database

  ## Examples

      iex> get_group_code("general")
      1

  """
  @spec get_group_code(String.t()) :: integer
  def get_group_code(program) do
    case program do
      "general" -> @general_code
      "advanced" -> @advanced_code
      "companion" -> @companion_code
      "companion2H" -> @companion2H_code
    end
  end

  @doc """
  Returns the list of receivers.

  ## Examples

      iex> list_receivers()
      [%Receiver{}, ...]

  """
  @spec list_receivers() :: [receiver]
  def list_receivers do
    Repo.all(Receiver)
  end

  @doc """
  Returns count each group of receivers. It ALWAYS has key `general`, `advanced`
  `companion` and `companion2H`. even the count is 0.

  ## Examples

      iex> count_receiver_groups()
      %{general: 3, advanced: 0, companion: 1, companion: 3}

  """
  @spec count_receiver_groups() :: map
  def count_receiver_groups() do
    query =
      from r in Receiver,
        group_by: r.group,
        order_by: r.group,
        select: {r.group, count()}

    base = [general: 0, advanced: 0, companion: 0, companion2H: 0] |> Enum.into(%{})

    Repo.all(query)
    |> Enum.into(%{})
    |> Map.merge(base, fn _key, val_a, val_b ->
      val_a + val_b
    end)
  end

  @doc """
  Gets a single receiver.

  Raises `Ecto.NoResultsError` if the Receiver does not exist.

  ## Examples

      iex> get_receiver!(123)
      %Receiver{}

      iex> get_receiver!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_receiver!(id :: integer()) :: receiver
  def get_receiver!(id), do: Repo.get!(Receiver, id)

  @doc """
    Retrieves a list of receivers to send based on their last update time.

    This function queries the database for receivers that meet the following criteria:

    1. The first time for user - If the inserted_at and updated_at timestamps are the same, the receiver is included.
    2. Each time after the first time for user - If the inserted_at and updated_at timestamps are different, the receiver is included only if the updated_at timestamp is older than 23 hours ago.

    The purpose of this function is to retrieve receivers that need to be sent some notification or action based on the criteria mentioned above.

    ## Examples

        iex> list_receivers_to_send()
        [%Receiver{}, ...]

    Returns a list of receivers that need to be sent notifications or actions.

    ## Notes

    - This function assumes that Receiver is an Ecto schema representing receivers.
    - The inserted_at and updated_at fields are assumed to be timestamps indicating the creation and last update times of the receiver, respectively.
  """
  @spec list_receivers_to_send() :: [receiver]
  def list_receivers_to_send() do
    query =
      from r in Receiver,
        where:
          r.inserted_at == r.updated_at or
            r.updated_at < ago(23, "hour")

    Repo.all(query)
  end

  @doc """
  Creates a receiver.

  ## Examples

      iex> create_receiver(%{field: value})
      {:ok, %Receiver{}}

      iex> create_receiver(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_receiver(map) :: {:ok, receiver} | {:error, Ecto.Changeset.t()}
  def create_receiver(attrs \\ %{}) do
    %Receiver{}
    |> Receiver.changeset(attrs)
    |> Repo.insert()
    |> broadcast_subscriber_count()
  end

  defp broadcast_subscriber_count({:ok, %Receiver{} = receiver}) do
    Phoenix.PubSub.broadcast(
      LineReminder.PubSub,
      "subscribers:#{receiver.group}",
      {:updated, receiver}
    )

    {:ok, receiver}
  end

  defp broadcast_subscriber_count(error), do: error

  @doc """
  Updates a receiver.

  ## Examples

      iex> update_receiver(receiver, %{field: new_value})
      {:ok, %Receiver{}}

      iex> update_receiver(receiver, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_receiver(receiver :: receiver, attrs :: map) ::
          {:ok, receiver} | {:error, Ecto.Changeset.t()}
  def update_receiver(%Receiver{} = receiver, attrs) do
    receiver
    |> Receiver.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates the `updated_at` field of the `Receiver` records with the provided tokens.

  This function takes a list of tokens (`tokens`) and updates the `updated_at` field
  of the corresponding `Receiver` records to the current UTC time.

  ## Parameters

    - `tokens` - A list of tokens representing the `Receiver` records to be updated.

  ## Returns

  A tuple containing the count of updated records and an optional entry (which is
  not used in this case).

  ## Examples

      iex> tokens = ["token1", "token2", "token3"]
      iex> LineReminder.Receivers.update_receivers(tokens)
      {3, nil}

  """
  @spec update_receivers([binary]) :: {non_neg_integer, nil}
  def update_receivers(tokens) when is_list(tokens) do
    listing_query =
      from r in Receiver,
        where: r.token in ^tokens

    query =
      from r in Receiver,
        join: l in subquery(listing_query),
        on: l.id == r.id,
        update: [
          set: [updated_at: ^DateTime.utc_now()]
        ]

    Repo.update_all(query, [])
  end

  @doc """
  Deletes a receiver.

  ## Examples

      iex> delete_receiver(receiver)
      {:ok, %Receiver{}}

      iex> delete_receiver(receiver)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_receiver(receiver :: receiver) ::
          {:ok, receiver} | {:error, Ecto.Changeset.t()}
  def delete_receiver(%Receiver{} = receiver) do
    Repo.delete(receiver)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking receiver changes.

  ## Examples

      iex> change_receiver(receiver)
      %Ecto.Changeset{data: %Receiver{}}

  """
  @spec change_receiver(receiver :: receiver, attrs :: map) :: Ecto.Changeset.t()
  def change_receiver(%Receiver{} = receiver, attrs \\ %{}) do
    Receiver.changeset(receiver, attrs)
  end
end
