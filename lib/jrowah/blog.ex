defmodule Jrowah.Blog do
  @moduledoc """
  The Blog context.
  """

  use NimblePublisher,
    build: Jrowah.Blog.Article,
    from: Application.app_dir(:jrowah, "priv/resources/articles/**/*.md"),
    as: :articles,
    html_converter: Jrowah.MarkdownConverter,
    highlighters: [:makeup_elixir, :makeup_erlang]

  # The @articles variable is first defined by NimblePublisher.
  # Let's further modify it by sorting all articles by descending date.
  @articles @articles
            |> Enum.filter(& &1.published)
            |> Enum.sort_by(& &1.date, {:desc, Date})

  # Let's also get all tags
  # This line of code is responsible for extracting all unique tags from the articles.
  # It does this by first flattening the list of tags from each article into a single list,
  # then removing any duplicates by using Enum.uniq(), and finally sorting the list of tags.
  # The result is a sorted list of all unique tags across all articles.
  @tags @articles
        |> Enum.flat_map(& &1.tags)
        |> Enum.uniq()
        |> Enum.sort()

  # And finally export them
  @spec all_articles() :: list
  def all_articles, do: @articles

  @spec all_tags() :: list
  def all_tags, do: @tags

  @spec get_articles_by_tag(String.t() | nil) :: []
  def get_articles_by_tag(tag) when is_nil(tag), do: @articles

  def get_articles_by_tag(tag) do
    Enum.filter(@articles, fn article ->
      Enum.any?(article.tags, fn t -> String.downcase(t) == String.downcase(tag) end)
    end)
  end

  @spec get_article_by_slug(String.t()) :: nil | map
  def get_article_by_slug(slug) do
    Enum.find(@articles, &(&1.slug == slug))
  end

  @spec recent_articles(count :: integer) :: []
  def recent_articles(count \\ 3), do: Enum.take(all_articles(), count)

  @spec get_linked_articles(current_article :: map) :: %{previous: map | nil, next: map | nil}
  def get_linked_articles(current_article) do
    %{
      previous: get_article_by_slug(current_article.previous_article_slug),
      next: get_article_by_slug(current_article.next_article_slug)
    }
  end
end
