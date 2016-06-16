defmodule Pomodoro.MacOsNotifier do
  def notify(description) do
    Pomodoro.MacOsNotification.send('Hands up!', description)
  end
end
