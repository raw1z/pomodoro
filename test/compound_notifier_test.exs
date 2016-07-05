defmodule CompoundNotifierTest do
  use ExUnit.Case, async: true
  alias Pomodoro.CompoundNotifier

  defmodule TestNotifier do
    def notify(description) do
      Agent.update(:compound_notifier_test, fn(buffer) ->
        [description|buffer]
      end)
    end
  end

  setup do
    Agent.start_link(fn -> [] end, name: :compound_notifier_test)
    CompoundNotifier.start_link
    :ok
  end

  test "add a notifier" do
    CompoundNotifier.add_notifier TestNotifier
    CompoundNotifier.notify "foo"
    Agent.get(:compound_notifier_test, fn buffer ->
      assert buffer == ["foo"]
    end)
  end

  test "remove notifier" do
    CompoundNotifier.add_notifier TestNotifier
    CompoundNotifier.notify "foo"
    CompoundNotifier.remove_notifier TestNotifier
    CompoundNotifier.notify "bar"
    Agent.get(:compound_notifier_test, fn buffer ->
      assert buffer == ["foo"]
    end)
  end
end
