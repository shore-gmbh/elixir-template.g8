defmodule Dory.Recurrence.Consumers.RecurrentAppointmentCreatedTest do
  use Dory.DataCase, async: false

  import ShoreService.AMQP.Test

  alias Dory.Recurrence.Consumers.RecurrentAppointmentCreated

  describe "RecurrentAppointmentCreated" do
    test "valid message is acknowledged and the rule is created on database" do
      message = valid_payload()

      enqueue(consumer: RecurrentAppointmentCreated, message_body: message)

      assert_success_message_received(message)

      rule_on_database =
        Dory.Recurrence.get_rule_by_series_id("1558f277-0ae0-448e-8c45-c771cbe02e9f")

      assert rule_on_database != nil
      assert rule_on_database.duration_in_minutes == 30
      assert rule_on_database.time_zone == "Europe/Berlin"
      assert rule_on_database.recurrence_frequency == "weekly"
      assert rule_on_database.recurrence_interval == 1
      assert rule_on_database.recurrence_count == nil
    end

    test "handle duplicated rule creation" do
      message = valid_payload()

      enqueue(consumer: RecurrentAppointmentCreated, message_body: message)

      assert_success_message_received(message)

      enqueue(consumer: RecurrentAppointmentCreated, message_body: message)

      assert_success_message_received(message)

      rule_on_database =
        Dory.Recurrence.get_rule_by_series_id("1558f277-0ae0-448e-8c45-c771cbe02e9f")

      assert rule_on_database != nil
      assert rule_on_database.duration_in_minutes == 30
      assert rule_on_database.time_zone == "Europe/Berlin"
      assert rule_on_database.recurrence_frequency == "weekly"
      assert rule_on_database.recurrence_interval == 1
      assert rule_on_database.recurrence_count == nil
    end

    test "message without required fields is rejected and the rule is not created on database" do
      message =
        %{
          appointment_series_id: "2b343dae-5510-4497-ae1d-377f2c6eec48"
        }
        |> Jason.encode!()

      enqueue(consumer: RecurrentAppointmentCreated, message_body: message)

      assert_error_message_received(message)

      rule_on_database =
        Dory.Recurrence.get_rule_by_series_id("2b343dae-5510-4497-ae1d-377f2c6eec48")

      assert rule_on_database == nil
    end

    test "message with invalid field values is rejected and the rule is not created on database" do
      message =
        %{
          appointment_series_id: "cdd41345-81bd-42a2-bea5-59e054be418e",
          duration_in_minutes: 60,
          time_zone: "Europe/Berlin",
          rules: [
            %{
              id: "80802d22-2107-4fe2-b763-3d357f3a745f",
              recurrence: %{
                frequency: "weekly",
                interval: 1,
                starts_at: "2022-01-27T10:00:00Z",
                ends_at: "2022-01-06T10:00:00Z",
                count: nil
              },
              meta: %{}
            }
          ],
          as_of: "2022-01-03T17:22:49.174+01:00"
        }
        |> Jason.encode!()

      enqueue(consumer: RecurrentAppointmentCreated, message_body: message)

      assert_error_message_received(message)

      rule_on_database =
        Dory.Recurrence.get_rule_by_series_id("2b343dae-5510-4497-ae1d-377f2c6eec48")

      assert rule_on_database == nil
    end
  end

  defp valid_payload do
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
    |> Jason.encode!()
  end
end
