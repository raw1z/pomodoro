defmodule CompoundNotifierTest do
  use ExUnit.Case

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
    :ok
  end

  test "add a notifier" do
    CompoundNotifier.add_notifier TestNotifier
    CompoundNotifier.notify "foo"
    Agent.get(:compound_notifier_test, fn buffer ->
      assert Enum.find(buffer, fn(x) -> x == "foo" end) != nil
    end)
  end

  test "remove notifier" do
    CompoundNotifier.add_notifier TestNotifier
    CompoundNotifier.notify "bar"
    CompoundNotifier.remove_notifier TestNotifier
    CompoundNotifier.notify "baz"
    Agent.get(:compound_notifier_test, fn buffer ->
      assert Enum.find(buffer, fn(x) -> x == "bar" end) != nil
      assert Enum.find(buffer, fn(x) -> x == "baz" end) == nil
    end)
  end
end
