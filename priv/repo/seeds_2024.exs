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
alias LineReminder.Events
alias LineReminder.ExcelHelper
alias LineReminder.Notifiers.Event

Repo.delete_all(Event)

unless Events.has_events_with_2024?() do
  events =
     Path.join(:code.priv_dir(:line_reminder), "/data/Reading_plan_2024.xlsx")
     |> ExcelHelper.import_all() 

  Repo.transaction(fn ->
    Enum.each(events, fn event ->
      Events.create_event(event)
    end)
  end)
end
