defmodule Pomodoro.Task do
  use Pomodoro.Web, :model

  schema "tasks" do
    field :description, :string
    field :done, :boolean, default: false

    timestamps
  end

  @required_fields ~w(description done)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
