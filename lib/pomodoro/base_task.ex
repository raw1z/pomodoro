defmodule Pomodoro.BaseTask do
  use GenServer

  # Public API

  def start(notifierClass, description, timeout) do
    GenServer.start_link __MODULE__, [notifierClass, description, timeout]
  end

  # GenServer implementation

  def init([notifierClass, description, timeout]) do
    Pomodoro.Timer.set_task(self, timeout)
    Pomodoro.Endpoint.broadcast "tasks:crud", "start", %{description: description, timeout: timeout}
    {:ok, %{notifierClass: notifierClass, description: description}}
  end

  def handle_info(:times_up, %{notifierClass: notifierClass, description: description}) do
    Pomodoro.Endpoint.broadcast "tasks:crud", "timesup", %{description: description, timeout: 0}
    notifierClass.notify(description)
    {:stop, :normal, nil}
  end

  def handle_info(:cancel, _state) do
    {:stop, :normal, nil}
  end
end
