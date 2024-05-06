defmodule LineReminder.Receivers do
  @moduledoc """
  The Receivers context.
  """

  import Ecto.Query, warn: false

  alias LineReminder.Repo
  alias LineReminder.Notifiers.Receiver

  @type receiver :: %LineReminder.Notifiers.Receiver{}

  @gernal_code 1
  @advanced_code 2
  @companion_code 3

  @doc """
  Reture corresponding prgoram code in database

  ## Examples

      iex> get_group_code("general")
      1

  """
  @spec get_group_code(String.t()) :: integer
  def get_group_code(program) do
    case program do
      "general" -> @gernal_code
      "advanced" -> @advanced_code
      "companion" -> @companion_code
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

  This function queries the database for receivers whose `updated_at` timestamp is older than 23 hours ago. The purpose of this function is to retrieve receivers that have not been updated within the specified time frame, possibly indicating that they need to be sent some notification or action.

  The reason for choosing "23 hours ago" instead of "1 day ago" is to mitigate potential time shifts that may occur in batch job scheduling. When batch jobs involving sending API requests are executed repeatedly, the execution time may vary slightly due to system load or scheduling delays. Using "23 hours ago" helps accommodate these variations and ensures the fault tolerance of this function.

  ## Examples

      iex> list_receivers_to_send()
      [%Receiver{}, ...]

  Returns a list of receivers that need to be sent notifications or actions.

  ## Notes

  - This function assumes that `Receiver` is an Ecto schema representing receivers.
  - The `updated_at` field is assumed to be a timestamp indicating the last time the receiver was updated.

  """
  @spec list_receivers_to_send() :: [receiver]
  def list_receivers_to_send() do
    query =
      from r in Receiver,
        where: r.updated_at < ago(23, "hour")

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
  end

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
