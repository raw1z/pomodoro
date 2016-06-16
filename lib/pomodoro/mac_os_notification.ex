defmodule Pomodoro.MacOsNotification do
  @template "terminal-notifier -group 'pomodoro' -title '<%= title %>' -message '<%= message %>' -sound 'default' -contentImage 'http://localhost:4000/images/pomodoro.icns'"

  def send(title, message) do
    command = EEx.eval_string(@template, title: title, message: message)
    Port.open({:spawn, command}, [])
  end
end
