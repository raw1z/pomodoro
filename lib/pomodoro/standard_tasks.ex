defmodule Pomodoro.StandardTask do
  def start(notifierClass, description) do
    BaseTask.start_link(notifierClass, description, 150_0000)
  end
end
