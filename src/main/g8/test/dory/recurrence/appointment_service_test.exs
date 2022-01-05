defmodule Dory.Recurrence.AppointmentServiceTest do
  use Dory.DataCase, async: false
  use GenRMQ.RabbitCase

  alias Dory.Recurrence.AppointmentService
  alias Dory.Recurrence.Repository

  @exchange "public"
  @connection Application.compile_env(:dory, :rabbitmq_url)
  @out_queue "gen_rmq_out_queue"

  setup_all do
    {:ok, conn} = rmq_open(@connection)
    :ok = setup_out_queue(conn, @out_queue, @exchange)
    {:ok, rabbit_conn: conn, out_queue: @out_queue}
  end

  setup do
    purge_queues(@connection, [@out_queue])
  end

  describe "when generating appointments by monthly infinite rule" do
    test "it publishes 12 messages and updates the next_occurrence_at", context do
      rule =
        %{
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
        |> create_rule()

      AppointmentService.generate_by_rule(rule)

      assert out_queue_count(context) == 12

      db_rule = Repository.get_rule_by_series_id(rule.series_id)

      assert db_rule.next_occurrence_at == ~U[2016-06-20 10:00:00Z]
    end
  end

  describe "when generating appointments by weekly infinite rule" do
    test "it publishes 52 messages", context do
      rule =
        %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          deleted_at: nil,
          duration_in_minutes: 60,
          time_zone: "Europe/Berlin",
          recurrence_frequency: "weekly",
          recurrence_interval: 1,
          recurrence_starts_at: ~U[2015-06-20 10:00:00Z],
          recurrence_ends_at: nil,
          recurrence_count: nil,
          next_occurrence_at: nil
        }
        |> create_rule()

      AppointmentService.generate_by_rule(rule)

      db_rule = Repository.get_rule_by_series_id(rule.series_id)

      assert db_rule.next_occurrence_at == ~U[2016-06-18 10:00:00Z]

      assert out_queue_count(context) == 52
    end
  end

  describe "when generating appointments by daily infinite rule" do
    test "it publishes 365 messages", context do
      rule =
        %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          deleted_at: nil,
          duration_in_minutes: 60,
          time_zone: "Europe/Berlin",
          recurrence_frequency: "daily",
          recurrence_interval: 1,
          recurrence_starts_at: ~U[2015-06-20 10:00:00Z],
          recurrence_ends_at: nil,
          recurrence_count: nil,
          next_occurrence_at: nil
        }
        |> create_rule()

      AppointmentService.generate_by_rule(rule)

      assert out_queue_count(context) == 365

      db_rule = Repository.get_rule_by_series_id(rule.series_id)

      assert db_rule.next_occurrence_at == ~U[2016-06-19 10:00:00Z]
    end
  end

  describe "when generating appointments by fixed count rule" do
    test "it publishes exacltly n messages", context do
      rule =
        %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          deleted_at: nil,
          duration_in_minutes: 60,
          time_zone: "Europe/Berlin",
          recurrence_frequency: "daily",
          recurrence_interval: 1,
          recurrence_starts_at: ~U[2015-06-20 10:00:00Z],
          recurrence_ends_at: nil,
          recurrence_count: 5,
          next_occurrence_at: nil
        }
        |> create_rule()

      AppointmentService.generate_by_rule(rule)

      assert out_queue_count(context) == 5
    end
  end

  describe "when generating appointments by max date rule" do
    test "it publishes the proper amount of messages", context do
      rule =
        %{
          series_id: "11cb4078-0a3f-47c7-8589-2c71aa0f353f",
          deleted_at: nil,
          duration_in_minutes: 60,
          time_zone: "Europe/Berlin",
          recurrence_frequency: "daily",
          recurrence_interval: 1,
          recurrence_starts_at: ~U[2015-06-20 10:00:00Z],
          recurrence_ends_at: ~U[2015-06-28 10:00:00Z],
          recurrence_count: nil,
          next_occurrence_at: nil
        }
        |> create_rule()

      AppointmentService.generate_by_rule(rule)

      assert out_queue_count(context) == 9
    end
  end

  defp create_rule(rule) do
    {:ok, rule} = Repository.create_rule(rule)
    rule
  end
end
