defmodule Pomodoro.StandardTask do
  def start(notifierClass, description) do
    Pomodoro.BaseTask.start(notifierClass, description, 150_0000)
  end
end
