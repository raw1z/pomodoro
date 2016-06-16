defmodule Pomodoro.MacOsNotifier do
  def notify(description) do
    Pomodoro.MacOsNotification.send('Times Up!', description)
  end
end
