# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LineReminder.Repo.insert!(%LineReminder.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias LineReminder.Repo
alias LineReminder.Reminders
alias LineReminder.Reminders.Event
alias LineReminder.DataDetailer

unless Reminders.has_events_with_2024?() do
  data =
    Enum.map(
      ["/data/2024_0.txt", "/data/2024_1.txt", "/data/2024_2.txt", "/data/2024_3.txt"],
      &Path.join(:code.priv_dir(:line_reminder), &1)
    )

  events =
    data
    |> Enum.into([], &DataDetailer.transform/1)
    |> List.flatten()

  Repo.transaction(fn ->
    Enum.each(events, fn event ->
      Reminders.create_event(event)
    end)
  end)
end
