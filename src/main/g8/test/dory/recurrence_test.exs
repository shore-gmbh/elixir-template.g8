defmodule Dory.RecurrenceTest do
  use Dory.DataCase, async: false

  alias Dory.Recurrence

  describe "parse_message/1 with valid attrs" do
    test "returns valid data" do
      attrs = valid_attrs()
      {:ok, parsed_message} = Recurrence.parse_message(attrs)

      assert parsed_message == %{
               deleted_at: nil,
               duration_in_minutes: 30,
               next_occurrence_at: nil,
               recurrence_count: nil,
               recurrence_ends_at: nil,
               recurrence_frequency: "weekly",
               recurrence_interval: 1,
               recurrence_starts_at: ~U[2021-12-30 14:00:00Z],
               series_id: "1558f277-0ae0-448e-8c45-c771cbe02e9f",
               time_zone: "Europe/Berlin"
             }
    end
  end

  defp valid_attrs do
    %{
      appointment_series_id: "1558f277-0ae0-448e-8c45-c771cbe02e9f",
      duration_in_minutes: 30,
      time_zone: "Europe/Berlin",
      rules: [
        %{
          id: "ec8b1273-27d0-484d-812c-db3acda3cc25",
          recurrence: %{
            frequency: "weekly",
            interval: 1,
            starts_at: "2021-12-30T14:00:00Z",
            ends_at: nil,
            count: nil
          },
          meta: %{}
        }
      ],
      as_of: "2021-12-28T20:39:35.395+01:00"
    }
  end
end
