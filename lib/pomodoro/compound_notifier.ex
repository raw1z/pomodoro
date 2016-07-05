defmodule Pomodoro.CompoundNotifier do
  def start_link do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add_notifier(notifierClass) do
    Agent.update(__MODULE__, fn (notifiers) ->
      [notifierClass|notifiers]
    end)
  end

  def remove_notifier(notifierClass) do
    Agent.update(__MODULE__, &Enum.filter(&1, fn(notifier) -> notifierClass != notifier end))
  end

  def notify(description) do
    Agent.get(__MODULE__, fn notifiers ->
      Enum.each(notifiers, &(&1.notify(description)))
    end)
  end
end
