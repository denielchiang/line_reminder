defmodule LineReminder.ApostleTest do
  use LineReminder.DataCase, async: true

  import Mox

  alias LineReminder.Apostle

  # Mock modules
  setup :verify_on_exit!

  describe "send/0" do
    test "success when send" do
      # Call send/0
      assert :ok = Apostle.send()
    end
  end
end
