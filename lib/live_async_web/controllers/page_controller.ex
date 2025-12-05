defmodule LiveAsyncWeb.PageController do
  use LiveAsyncWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
