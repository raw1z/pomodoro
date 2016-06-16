defmodule Pomodoro.Timer do
  use GenServer

  # Public API

  @name :pomodoro_timer

  def start_link(timeout \\ 1_500_000) do
    GenServer.start_link __MODULE__, timeout, name: {:global, @name}
  end

  def set_task(pid) do
    @name
    |> :global.whereis_name
    |> GenServer.cast({:start, pid})
  end

  def status do
    @name
    |> :global.whereis_name
    |> GenServer.cast(:status)
  end

  # GenServer implementation

  def init(timeout) do
    {:ok, %{timeout: timeout}}
  end

  def handle_cast({:start, pid}, %{timeout: timeout}) do
    timer = Process.send_after(self, :times_up, timeout)
    {:noreply, %{timer: timer, timeout: timeout, pid: pid}}
  end

  def handle_cast(:status, %{timer: timer, pid: pid}) when do
    timer = Process.send_after(self, :times_up, timeout)
    {:noreply, %{timer: timer, timeout: timeout, pid: pid}}
  end

  def handle_info(:times_up, %{timer: timer, pid: pid, timeout: timeout}) do
    Process.cancel_timer(timer)
    send(pid, :times_up)
    {:noreply, %{timeout: timeout}}
  end
end
