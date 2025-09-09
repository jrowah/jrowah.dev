defmodule JrowahWeb.MetaTags do
  @moduledoc """
  Helper functions for generating SEO and social media meta tags
  """
  use Phoenix.Component

  import Phoenix.HTML

  @spec page_meta(map()) :: Phoenix.LiveView.Rendered.t()
  def page_meta(assigns) do
    ~H"""
    <!-- Primary Meta Tags -->
    <meta name="title" content={@title} />
    <meta name="description" content={@description} />
    <meta name="keywords" content={@keywords} />
    <meta name="author" content={@author} />
    <!-- Open Graph / Facebook -->
    <meta property="og:type" content={@og_type} />
    <meta property="og:url" content={@url} />
    <meta property="og:title" content={@title} />
    <meta property="og:description" content={@description} />
    <meta property="og:image" content={@og_image} />
    <meta property="og:image:alt" content={@og_image_alt} />
    <meta property="og:site_name" content="JRowah - Software Developer" />
    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image" />
    <meta property="twitter:url" content={@url} />
    <meta property="twitter:title" content={@title} />
    <meta property="twitter:description" content={@description} />
    <meta property="twitter:image" content={@og_image} />
    <meta property="twitter:image:alt" content={@og_image_alt} />
    <meta name="twitter:creator" content="@jrowah" />
    <!-- Canonical URL -->
    <link :if={@canonical_url} rel="canonical" href={@canonical_url} />
    <!-- Article specific meta tags -->
    <meta :if={@article_author} property="article:author" content={@article_author} />
    <meta
      :if={@article_published_time}
      property="article:published_time"
      content={@article_published_time}
    />
    <meta
      :if={@article_modified_time}
      property="article:modified_time"
      content={@article_modified_time}
    />
    <meta :if={@article_section} property="article:section" content={@article_section} />
    <meta :for={tag <- @article_tags || []} property="article:tag" content={tag} />
    """
  end

  @spec structured_data(map()) :: Phoenix.LiveView.Rendered.t()
  def structured_data(assigns) do
    ~H"""
    <script type="application/ld+json">
      <%= raw(@json_ld) %>
    </script>
    """
  end

  @doc """
  Generate JSON-LD structured data for an article
  """
  @spec generate_article_json_ld(Jrowah.Blog.Article.t(), String.t()) :: String.t()
  def generate_article_json_ld(article, site_url) do
    Jason.encode!(%{
      "@context" => "https://schema.org",
      "@type" => "BlogPosting",
      "headline" => article.title,
      "description" => article.description,
      "image" => "#{site_url}#{article.og_image || article.hero_image}",
      "author" => %{
        "@type" => "Person",
        "name" => article.author,
        "url" => site_url
      },
      "publisher" => %{
        "@type" => "Organization",
        "name" => "JRowah",
        "url" => site_url,
        "logo" => %{
          "@type" => "ImageObject",
          "url" => "#{site_url}/images/logo.png"
        }
      },
      "datePublished" => Date.to_iso8601(article.date),
      "dateModified" => Date.to_iso8601(article.date),
      "mainEntityOfPage" => %{
        "@type" => "WebPage",
        "@id" => "#{site_url}/blog/#{article.slug}"
      },
      "keywords" => Enum.join(article.keywords || article.tags, ", "),
      "articleSection" => "Technology",
      "inLanguage" => "en-US",
      "url" => "#{site_url}/blog/#{article.slug}"
    })
  end

  @doc """
  Generate default meta tag attributes for a blog article
  """
  @spec article_meta_assigns(Jrowah.Blog.Article.t(), String.t()) :: map()
  def article_meta_assigns(article, site_url) do
    article_url = "#{site_url}/blog/#{article.slug}"

    og_image_url =
      case article.og_image || article.hero_image do
        nil -> "#{site_url}/images/default-og.png"
        "/" <> path -> "#{site_url}/#{path}"
        "http" <> _path = full_url -> full_url
        path -> "#{site_url}#{path}"
      end

    %{
      title: article.title,
      description: article.description,
      keywords: Enum.join(article.keywords || article.tags, ", "),
      author: article.author,
      og_type: "article",
      url: article_url,
      og_image: og_image_url,
      og_image_alt: "Cover image for: #{article.title}",
      canonical_url: article.canonical_url || article_url,
      article_author: article.author,
      article_published_time: Date.to_iso8601(article.date),
      article_modified_time: Date.to_iso8601(article.date),
      article_section: "Technology",
      article_tags: article.tags
    }
  end
end
