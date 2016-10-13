defmodule Pomodoro.TaskChannel do
  use Pomodoro.Web, :channel

  def join("tasks:crud", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("start", payload, socket) do
    broadcast socket, "start", payload
    {:noreply, socket}
  end

  def handle_in("run", %{"description" => description, "timeout" => timeout }, socket) do
    Pomodoro.BaseTask.start(Pomodoro.CompoundNotifier, description, timeout)
    {:noreply, socket}
  end

  def handle_in("timesup", payload, socket) do
    broadcast socket, "timesup", payload
    {:noreply, socket}
  end

  # This is invoked every time a notification is being broadcast
  # to the client. The default implementation is just to push it
  # downstream but one could filter or change the event.
  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end
end
