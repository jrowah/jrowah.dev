defmodule JrowahWeb.BlogLive.Show do
  @moduledoc false
  use JrowahWeb, :live_view

  alias Jrowah.Blog
  alias JrowahWeb.MetaTags

  @impl Phoenix.LiveView
  def mount(%{"slug" => slug} = _params, _session, socket) do
    case Blog.get_article_by_slug(slug) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Article not found")
         |> push_navigate(to: ~p"/blog")}

      article ->
        site_url = get_site_url()
        meta_assigns = MetaTags.article_meta_assigns(article, site_url)
        json_ld = MetaTags.generate_article_json_ld(article, site_url)

        {:ok,
         socket
         |> assign(:article, article)
         |> assign(:page_title, article.title)
         |> assign(:meta_assigns, meta_assigns)
         |> assign(:json_ld, json_ld)}
    end
  end

  defp get_site_url do
    Application.get_env(:jrowah, :site_url, "https://jrowah.dev")
  end
end
