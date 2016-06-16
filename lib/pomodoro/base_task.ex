defmodule Pomodoro.BaseTask do
  use GenServer

  # Public API

  def start_link(notifierClass, description, timeout) do
    GenServer.start_link __MODULE__, [notifierClass, description, timeout]
  end

  # GenServer implementation

  def init([notifierClass, description, timeout]) do
    Pomodoro.Timer.set_task(self, timeout)
    {:ok, %{notifierClass: notifierClass, description: description}}
  end

  def handle_info(:times_up, %{notifierClass: notifierClass, description: description}) do
    notifierClass.notify(description)
    {:stop, :normal, nil}
  end
end
