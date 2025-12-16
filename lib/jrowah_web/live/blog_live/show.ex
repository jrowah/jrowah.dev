defmodule JrowahWeb.BlogLive.Show do
  @moduledoc false
  use JrowahWeb, :live_view

  alias Jrowah.Blog
  alias JrowahWeb.MetaTags
  alias JrowahWeb.Presence

  @presence_key "live_reading"

  @impl Phoenix.LiveView
  def mount(%{"slug" => slug} = _params, _session, socket) do
    case Blog.get_article_by_slug(slug) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Article not found")
         |> push_navigate(to: ~p"/blog")}

      article ->
        if connected?(socket) do
          Phoenix.PubSub.subscribe(Jrowah.PubSub, "article:#{article.id}")
          {:ok, _refs} = Presence.track(self(), "article:#{article.id}", @presence_key, %{})
        end

        live_reading = get_live_readers_count(article.id)
        site_url = get_site_url()
        meta_assigns = MetaTags.article_meta_assigns(article, site_url)
        json_ld = MetaTags.generate_article_json_ld(article, site_url)

        {:ok,
         socket
         |> assign(:article, article)
         |> assign(:page_title, article.title)
         |> assign(:live_reading, live_reading)
         |> assign(:meta_assigns, meta_assigns)
         |> assign(:linked_articles, Blog.get_linked_articles(article))
         |> assign(:json_ld, json_ld)}
    end
  end

  @impl Phoenix.LiveView
  def handle_info(%{event: "presence_diff"}, socket) do
    article = socket.assigns.article
    live_reading = get_live_readers_count(article.id)
    {:noreply, assign(socket, :live_reading, live_reading)}
  end

  defp get_site_url do
    Application.get_env(:jrowah, :site_url, "https://jrowah.dev")
  end

  defp get_live_readers_count(article_id) do
    presences = Presence.list("article:#{article_id}")

    # Count all metas across all presence entries
    Enum.reduce(presences, 0, fn {_key, %{metas: metas}}, acc ->
      acc + length(metas)
    end)
  end
end
