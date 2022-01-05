defmodule Dory.Recurrence.AppointmentCalculatorTest do
  use Dory.DataCase, async: false

  alias Dory.Recurrence.AppointmentCalculator
  alias Support.AppointmentFixtures, as: Fixtures

  describe ".calculate/1" do
    test "calculates monthly appointments for a year" do
      rule = %{
        series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
        deleted_at: nil,
        duration_in_minutes: 60,
        time_zone: "Europe/Berlin",
        recurrence_frequency: "monthly",
        recurrence_interval: 1,
        recurrence_starts_at: ~U[2015-06-20 10:00:00Z],
        recurrence_ends_at: nil,
        recurrence_count: nil,
        next_occurrence_at: nil
      }

      occurrences = AppointmentCalculator.calculate_by_count(rule, 12)

      assert occurrences == Fixtures.monthly_appointments()
      assert Enum.count(occurrences) == 12
    end

    test "calculates weekly appointments correctly" do
      rule = %{
        series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
        deleted_at: nil,
        duration_in_minutes: 60,
        time_zone: "Europe/Berlin",
        recurrence_frequency: "weekly",
        recurrence_interval: 1,
        recurrence_starts_at: ~U[2021-12-20 10:00:00Z],
        recurrence_ends_at: nil,
        recurrence_count: nil,
        next_occurrence_at: nil
      }

      expected_result = [
        %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          starts_at: ~U[2021-12-20T10:00:00Z],
          ends_at: ~U[2021-12-20T11:00:00Z]
        },
        %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          starts_at: ~U[2021-12-27T10:00:00Z],
          ends_at: ~U[2021-12-27T11:00:00Z]
        },
        %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          starts_at: ~U[2022-01-03T10:00:00Z],
          ends_at: ~U[2022-01-03T11:00:00Z]
        },
        %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          starts_at: ~U[2022-01-10T10:00:00Z],
          ends_at: ~U[2022-01-10T11:00:00Z]
        }
      ]

      occurrences = AppointmentCalculator.calculate_by_count(rule, 4)

      assert occurrences == expected_result
    end

    test "calculates daily appointments correctly" do
      rule = %{
        series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
        deleted_at: nil,
        duration_in_minutes: 60,
        time_zone: "Europe/Berlin",
        recurrence_frequency: "daily",
        recurrence_interval: 1,
        recurrence_starts_at: ~U[2021-12-20 10:00:00Z],
        recurrence_ends_at: nil,
        recurrence_count: nil,
        next_occurrence_at: nil
      }

      expected_results = [
        %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          starts_at: ~U[2021-12-20T10:00:00Z],
          ends_at: ~U[2021-12-20T11:00:00Z]
        },
        %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          starts_at: ~U[2021-12-21T10:00:00Z],
          ends_at: ~U[2021-12-21T11:00:00Z]
        },
        %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          starts_at: ~U[2021-12-22T10:00:00Z],
          ends_at: ~U[2021-12-22T11:00:00Z]
        },
        %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          starts_at: ~U[2021-12-23T10:00:00Z],
          ends_at: ~U[2021-12-23T11:00:00Z]
        }
      ]

      occurrences = AppointmentCalculator.calculate_by_count(rule, 4)

      assert occurrences == expected_results
    end

    test "creates occurrences until recurrence_ends_at" do
      rule = %{
        series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
        deleted_at: nil,
        duration_in_minutes: 60,
        time_zone: "Europe/Berlin",
        recurrence_frequency: "monthly",
        recurrence_interval: 1,
        recurrence_starts_at: ~U[2021-12-30 10:00:00Z],
        recurrence_ends_at: ~U[2022-03-30 10:00:00Z],
        recurrence_count: nil,
        next_occurrence_at: nil
      }

      assert AppointmentCalculator.calculate_until(rule, rule.recurrence_ends_at) == [
               %{
                 series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
                 starts_at: ~U[2021-12-30T10:00:00Z],
                 ends_at: ~U[2021-12-30T11:00:00Z]
               },
               %{
                 series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
                 starts_at: ~U[2022-01-30T10:00:00Z],
                 ends_at: ~U[2022-01-30T11:00:00Z]
               },
               %{
                 series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
                 starts_at: ~U[2022-02-28T10:00:00Z],
                 ends_at: ~U[2022-02-28T11:00:00Z]
               },
               %{
                 series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
                 starts_at: ~U[2022-03-30T09:00:00Z],
                 ends_at: ~U[2022-03-30T10:00:00Z]
               }
             ]
    end
  end
end
