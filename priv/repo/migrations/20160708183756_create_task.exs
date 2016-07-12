defmodule Pomodoro.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :descripton, :string
      add :done, :boolean, default: false

      timestamps
    end

  end
end
