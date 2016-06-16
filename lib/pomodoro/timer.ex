defmodule Pomodoro.Timer do
  use GenServer

  # Public API

  @name :pomodoro_timer

  def start_link() do
    GenServer.start_link __MODULE__, nil, name: {:global, @name}
  end

  def set_task(pid, timeout) do
    @name
    |> :global.whereis_name
    |> GenServer.cast({:start, pid, timeout})
  end

  # GenServer implementation

  def init(nil) do
    {:ok, nil}
  end

  def handle_cast({:start, pid, timeout}, _state) do
    timer = Process.send_after(self, :times_up, timeout)
    {:noreply, %{timer: timer, pid: pid}}
  end

  def handle_info(:times_up, %{timer: timer, pid: pid}) do
    Process.cancel_timer(timer)
    send(pid, :times_up)
    {:noreply, nil}
  end
end
