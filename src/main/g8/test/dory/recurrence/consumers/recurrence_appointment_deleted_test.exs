defmodule Dory.Recurrence.Consumers.RecurrentAppointmentDeletedTest do
  use Dory.DataCase, async: false

  import ShoreService.AMQP.Test

  alias Dory.Recurrence.Repository
  alias Dory.Recurrence.Consumers.RecurrentAppointmentDeleted

  describe "when consuming appointment.recurrent.v1.deleted" do
    test "valid message is acknowledged and the rule is soft deleted from the database" do
      rule = %{
        series_id: "34eab487-1141-4672-93d9-72f46e1b2ead",
        deleted_at: nil,
        duration_in_minutes: 30,
        time_zone: "Europe/Berlin",
        recurrence_frequency: "monthly",
        recurrence_interval: 1,
        recurrence_starts_at: "2021-12-30T14:00:00Z",
        recurrence_ends_at: nil,
        recurrence_count: nil,
        next_occurrence_at: nil
      }

      {:ok, _db_rule} = Repository.create_rule(rule)

      deleted_at = "2021-12-30T15:00:00Z"

      message = delete_message(rule.series_id, deleted_at)

      enqueue(consumer: RecurrentAppointmentDeleted, message_body: message)

      assert_success_message_received(message)

      db_rule = Repository.get_rule_by_series_id(rule.series_id)

      assert db_rule.deleted_at == ~U[2021-12-30 15:00:00Z]
    end

    test "rule is soft deleted event without as-of on the message" do
      rule = %{
        series_id: "34eab487-1141-4672-93d9-72f46e1b2ead",
        deleted_at: nil,
        duration_in_minutes: 30,
        time_zone: "Europe/Berlin",
        recurrence_frequency: "monthly",
        recurrence_interval: 1,
        recurrence_starts_at: "2021-12-30T14:00:00Z",
        recurrence_ends_at: nil,
        recurrence_count: nil,
        next_occurrence_at: nil
      }

      {:ok, _db_rule} = Repository.create_rule(rule)

      message = delete_message(rule.series_id, nil)

      enqueue(consumer: RecurrentAppointmentDeleted, message_body: message)

      assert_success_message_received(message)

      db_rule = Repository.get_rule_by_series_id(rule.series_id)

      assert(db_rule.deleted_at != nil)
    end

    test "persists a new rule when series_id is not found" do
      series_id = "89162297-1ccf-44c4-8f7f-d9214e4bb3bc"
      message = delete_message(series_id, nil)

      enqueue(consumer: RecurrentAppointmentDeleted, message_body: message)

      assert_success_message_received(message)

      db_rule = Repository.get_rule_by_series_id(series_id)

      assert(db_rule.deleted_at != nil)
    end

    test "does not persist the soft deletion when message payload is invalid" do
      rule = %{
        series_id: "34eab487-1141-4672-93d9-72f46e1b2ead",
        deleted_at: nil,
        duration_in_minutes: 30,
        time_zone: "Europe/Berlin",
        recurrence_frequency: "monthly",
        recurrence_interval: 1,
        recurrence_starts_at: "2021-12-30T14:00:00Z",
        recurrence_ends_at: nil,
        recurrence_count: nil,
        next_occurrence_at: nil
      }

      {:ok, _db_rule} = Repository.create_rule(rule)

      message =
        %{
          appointment_series_id: rule.series_id,
          as_of: "invalid as_of"
        }
        |> Jason.encode!()

      enqueue(consumer: RecurrentAppointmentDeleted, message_body: message)

      assert_error_message_received(message)

      db_rule = Repository.get_rule_by_series_id(rule.series_id)

      assert is_nil(db_rule.deleted_at)
    end
  end

  defp delete_message(series_id, deleted_at) do
    %{
      appointment_series_id: series_id,
      as_of: deleted_at
    }
    |> Jason.encode!()
  end
end
