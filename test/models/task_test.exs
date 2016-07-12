defmodule Pomodoro.TaskTest do
  use Pomodoro.ModelCase

  alias Pomodoro.Task

  @valid_attrs %{description: "some content", done: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Task.changeset(%Task{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Task.changeset(%Task{}, @invalid_attrs)
    refute changeset.valid?
  end
end
