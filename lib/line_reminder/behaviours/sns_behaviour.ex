defmodule LineReminder.SnsBehaviour do
  @moduledoc false

  @callback send_congrats(String.t(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @callback send_progress(String.t(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @callback send_to_group(map(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
end
