defmodule JrowahWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use JrowahWeb, :controller
      use JrowahWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  @spec static_paths() :: list(String.t())
  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  @spec router() :: any()
  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  @spec channel() :: any()
  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  @spec controller() :: any()
  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: JrowahWeb.Layouts]

      import Plug.Conn
      import JrowahWeb.Gettext

      unquote(verified_routes())
    end
  end

  @spec live_view() :: any()
  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {JrowahWeb.Layouts, :app}

      unquote(html_helpers())
    end
  end

  @spec live_component() :: any()
  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  @spec html() :: any()
  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import JrowahWeb.CoreComponents
      import JrowahWeb.Gettext

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  @spec verified_routes() :: any()
  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: JrowahWeb.Endpoint,
        router: JrowahWeb.Router,
        statics: JrowahWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
