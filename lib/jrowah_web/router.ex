defmodule JrowahWeb.Router do
  use JrowahWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JrowahWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JrowahWeb do
    pipe_through :browser

    live_session :default, on_mount: JrowahWeb.InitialAssigns do
      live "/", HomeLive.Index, :index
      live "/blog", BlogLive.Index, :index
      live "/blog/tag/:tag", BlogLive.Index, :index
      live "/blog/:slug", BlogLive.Show, :show
      live "/journey", JourneyLive.Index, :index
      live "/projects", ProjectsLive.Index, :index
      live "/cookies-policy", CookiesLive.Index, :index
      live "/privacy-policy", PrivacyLive.Index, :index
      live "/legal-terms", TermsLive.Index, :index
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", JrowahWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:jrowah, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JrowahWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/*rest", JrowahWeb do
    pipe_through :browser
    match(:*, "/", PageController, :not_found)
  end
end
