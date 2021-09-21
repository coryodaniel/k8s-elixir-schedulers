defmodule K8sSchedulers do
  require Logger

  def log_scheduler_details() do
    avail = :erlang.system_info(:logical_processors_available)
    count = :erlang.system_info(:schedulers)
    online = :erlang.system_info(:schedulers_online)

    Logger.info("Schedulers")
    Logger.info("\tlogical_processors_available: #{avail}")
    Logger.info("\tschedulers: #{count}")
    Logger.info("\tschedulers_online: #{online}")
    :ok
  end

  def run(nth_prime \\ 100_000) do
    online_scheduler_count = :erlang.system_info(:schedulers_online)
    tasks = (1..online_scheduler_count)
    log_scheduler_details()
    Enum.each(tasks, fn task_id ->
      Task.Supervisor.start_child(K8sSchedulers.TaskSupervisor, fn ->
        Logger.metadata(task_id: task_id, nth_prime: nth_prime)
        Logger.info "Starting calculation"
        {prime, _} = K8sSchedulers.Prime.nth_prime(nth_prime)
        Logger.info "Finished calculation: #{prime}"
      end)
    end)
  end

  defmodule Prime do
    def nth_prime(n) do
      Stream.iterate(1, &(&1 + 1))
      |> Stream.filter(&prime?(&1))
      |> Stream.with_index(1)
      |> Enum.find(fn {_prime, x} -> x == n end)
    end

    def prime?(1), do: false
    def prime?(2), do: true
    def prime?(3), do: true
    def prime?(5), do: true
    def prime?(7), do: true
    def prime?(n) when rem(n, 2) == 0, do: false
    def prime?(n) do
      limit = [7, round(:math.sqrt(n))] |> Enum.max

      Stream.iterate(3, &(&1 + 2))
      |> Stream.take_while(fn x -> x <= limit end)
      |> Stream.filter(fn x -> rem(n,x) == 0 end)
      |> Enum.empty?
    end
  end
end
