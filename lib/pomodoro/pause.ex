defmodule Pomodoro.Pause do
  def start(notifierClass) do
    BaseTask.start_link(notifierClass, "Pause", 30_0000)
  end
end
