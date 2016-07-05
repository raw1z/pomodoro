defmodule Pomodoro.LongPause do
  alias Pomodoro.CompoundNotifier

  def start(description \\ "Long pause") do
    Pomodoro.BaseTask.start(CompoundNotifier, description, 1_200_000)
  end
end
