defmodule JrowahWeb.PageController do
  @moduledoc false
  use JrowahWeb, :controller

  @spec not_found(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def not_found(conn, _params) do
    conn
    |> assign(:page_title, "Page Not Found")
    |> assign(:current_url, conn.request_path)
    |> render("404.html")
  end
end
