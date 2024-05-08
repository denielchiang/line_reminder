defmodule LineReminder.ExcelHelperTest do
  use LineReminder.DataCase, async: true

  @moduletag capture_log: true

  alias LineReminder.ExcelHelper
  alias LineReminder.Events

  setup_all do
    [
      file_path: Path.join(:code.priv_dir(:line_reminder), "/data/Reading_plan_2024_test.xlsx")
    ]
  end

  describe "import_all/1" do
    test "imports data from all sheet types", %{file_path: test_file_path} do
      expected_output = [
        %{name: "Chapter1", date: ~N[2023-05-01 00:00:00], group: 1},
        %{name: "Chapter2", date: ~N[2023-05-02 00:00:00], group: 1},
        %{name: "Chapter3", date: ~N[2023-05-03 00:00:00], group: 1},
        %{name: "Chapter4", date: ~N[2023-05-04 00:00:00], group: 2},
        %{name: "Chapter5", date: ~N[2023-05-05 00:00:00], group: 2},
        %{name: "Chapter6", date: ~N[2023-05-06 00:00:00], group: 2},
        %{name: "Chapter7", date: ~N[2023-05-07 00:00:00], group: 3},
        %{name: "Chapter8", date: ~N[2023-05-08 00:00:00], group: 3},
        %{name: "Chapter9", date: ~N[2023-05-09 00:00:00], group: 3}
      ]

      assert ExcelHelper.import_all(test_file_path) == expected_output
    end
  end

  describe "import_sheet/2" do
    test "imports data from a specific sheet type", %{file_path: test_file_path} do
      expected_output = [
        %{name: "Chapter1", date: ~N[2023-05-01 00:00:00], group: 1},
        %{name: "Chapter2", date: ~N[2023-05-02 00:00:00], group: 1},
        %{name: "Chapter3", date: ~N[2023-05-03 00:00:00], group: 1}
      ]

      assert ExcelHelper.import_sheet(test_file_path, {:general, 0}) == expected_output
    end

    test "returns an empty list for an invalid sheet index", %{file_path: test_file_path} do
      expected_output = {:error, "Invalid worksheet index."}
      assert ExcelHelper.import_sheet(test_file_path, {:general, 100}) == expected_output
    end

    test "import 9 rows of events data", %{file_path: test_file_path} do
      events = ExcelHelper.import_all(test_file_path)

      Repo.transaction(fn ->
        Enum.each(events, fn event ->
          Events.create_event(event)
        end)
      end)

      quried_events = Events.list_events()
      assert length(quried_events)
    end
  end

  describe "build_map/2" do
    test "builds a map with the correct keys and values" do
      date = ~N[2023-05-01 00:00:00]
      chapter = "Chapter1"
      group = :general

      expected_output = %{name: "Chapter1", date: ~N[2023-05-01 00:00:00], group: 1}

      assert ExcelHelper.build_map([date, chapter], group) == expected_output
    end
  end

  describe "fit_structs_group/1" do
    test "returns the correct integer value for each group" do
      assert ExcelHelper.fit_structs_group(:general) == 1
      assert ExcelHelper.fit_structs_group(:advanced) == 2
      assert ExcelHelper.fit_structs_group(:companion) == 3
    end
  end

  describe "extract_sheet/2" do
    test "returns an error tuple for a nil file path" do
      assert ExcelHelper.extract_sheet(nil, 0) == {:parser, {:error, "path is nil"}}
    end

    test "returns an error tuple for a non-existent file" do
      assert ExcelHelper.extract_sheet("non_existent_file.xlsx", 0) ==
               {:error, "file is not exist"}
    end
  end
end
