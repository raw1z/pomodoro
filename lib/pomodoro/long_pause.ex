defmodule Pomodoro.LongPause do
  def start(notifierClass) do
    Pomodoro.BaseTask.start(notifierClass, "Long pause", 1_200_000)
  end
end
