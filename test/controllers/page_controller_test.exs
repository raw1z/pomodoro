defmodule Pomodoro.PageControllerTest do
  use Pomodoro.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert String.length(html_response(conn, 200)) > 0
  end
end
