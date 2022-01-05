defmodule Dory.Recurrence.RuleTest do
  use Dory.DataCase, async: false

  alias Dory.Recurrence.Rule

  describe ".changeset/2 with recurrence_ends_at date before recurrence_starts_at date" do
    test "returns validation error" do
      changeset =
        Rule.changeset(%Rule{}, %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          deleted_at: nil,
          duration_in_minutes: 60,
          time_zone: "Europe/Berlin",
          recurrence_frequency: "monthly",
          recurrence_interval: 1,
          recurrence_starts_at: ~U[2015-06-20 10:00:00Z],
          recurrence_ends_at: ~U[2015-06-19 10:00:00Z],
          recurrence_count: nil,
          next_occurrence_at: nil
        })

      refute changeset.valid?

      assert changeset.errors == [
               recurrence_ends_at: {"date value must be after :recurrence_starts_at", []}
             ]
    end
  end

  describe ".changeset/2 with recurrence_ends_at date after recurrence_starts_at date" do
    test "returns validation error" do
      changeset =
        Rule.changeset(%Rule{}, %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          deleted_at: nil,
          duration_in_minutes: 60,
          time_zone: "Europe/Berlin",
          recurrence_frequency: "monthly",
          recurrence_interval: 1,
          recurrence_starts_at: ~U[2015-06-20 10:00:00Z],
          recurrence_ends_at: ~U[2015-06-21 10:00:00Z],
          recurrence_count: nil,
          next_occurrence_at: nil
        })

      assert changeset.valid?
    end
  end
end
