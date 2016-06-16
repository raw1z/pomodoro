defmodule Pomodoro.Pause do
  def start(notifierClass) do
    Pomodoro.BaseTask.start(notifierClass, "Pause", 30_0000)
  end
end
