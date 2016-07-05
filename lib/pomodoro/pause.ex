defmodule Pomodoro.Pause do
  alias Pomodoro.CompoundNotifier

  def start(description \\ "Pause") do
    Pomodoro.BaseTask.start(CompoundNotifier, description, 30_0000)
  end
end
