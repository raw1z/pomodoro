defmodule Pomodoro.StandardTask do
  alias Pomodoro.CompoundNotifier

  def start(description) do
    Pomodoro.BaseTask.start(CompoundNotifier, description, 150_0000)
  end
end
