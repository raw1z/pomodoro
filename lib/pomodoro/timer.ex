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

  def status() do
    @name
    |> :global.whereis_name
    |> GenServer.call(:status)
  end

  def stop() do
    @name
    |> :global.whereis_name
    |> GenServer.cast(:stop)
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

  def handle_call(:status, _from, nil) do
    {:reply, :idle, nil}
  end

  def handle_call(:status, _from, %{timer: timer, pid: pid}=state) do
    remainingTime = Process.read_timer(timer)/1000
    minutesInRemainingTime = Float.floor(remainingTime/60) |> round
    secondsInRemainingTime = (remainingTime - (minutesInRemainingTime * 60)) |> round
    {:reply, {:running, {minutesInRemainingTime, secondsInRemainingTime}, pid}, state}
  end

  def handle_cast(:stop, _from, %{timer: timer, pid: pid}) do
    Process.cancel_timer(timer)
    send(pid, :cancel)
    {:noreply, nil}
  end

  def handle_cast(:stop, nil) do
    {:noreply, nil}
  end
end
