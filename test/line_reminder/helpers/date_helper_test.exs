defmodule LineReminder.DateHelperTest do
  use LineReminder.DataCase

  alias LineReminder.DateHelper

  describe "taiwan_today/0" do
    test "returns today's date in the Taiwan timezone" do
      taipei_today =
        DateTime.now!("Asia/Taipei") |> DateTime.to_date()

      assert DateHelper.taiwan_today() == taipei_today
    end
  end
end
