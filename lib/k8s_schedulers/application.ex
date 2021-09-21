defmodule K8sSchedulers.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: K8sSchedulers.TaskSupervisor}
    ]
    opts = [strategy: :one_for_one, name: K8sSchedulers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
