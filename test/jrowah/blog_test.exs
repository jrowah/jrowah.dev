defmodule Jrowah.BlogTest do
  use ExUnit.Case, async: true

  alias Jrowah.Blog
  alias Jrowah.Blog.Article

  describe "all_articles/0" do
    test "returns a list of published articles" do
      articles = Blog.all_articles()

      assert is_list(articles)
      assert Enum.all?(articles, &(&1.published == true))

      # Articles should be sorted by date in descending order
      dates = Enum.map(articles, & &1.date)
      assert dates == Enum.sort(dates, {:desc, Date})
    end

    test "all articles have required fields" do
      articles = Blog.all_articles()

      Enum.each(articles, fn article ->
        assert %Article{} = article
        assert is_binary(article.id)
        assert is_binary(article.slug)
        assert is_binary(article.title)
        assert is_binary(article.body)
        assert is_binary(article.description)
        assert is_list(article.tags)
        assert %Date{} = article.date
        assert is_integer(article.reading_time)
        assert is_binary(article.hero_image)
        assert article.published == true
      end)
    end
  end

  describe "all_tags/0" do
    test "returns a sorted list of unique tags" do
      tags = Blog.all_tags()

      assert is_list(tags)
      assert tags == Enum.sort(tags)
      assert tags == Enum.uniq(tags)
    end
  end

  describe "get_articles_by_tag/1" do
    test "returns all articles when tag is nil" do
      articles_by_nil = Blog.get_articles_by_tag(nil)
      all_articles = Blog.all_articles()

      assert articles_by_nil == all_articles
    end

    test "returns articles with the specified tag (case insensitive)" do
      # Get a tag from existing articles
      all_articles = Blog.all_articles()

      if length(all_articles) > 0 do
        first_article = hd(all_articles)

        if length(first_article.tags) > 0 do
          tag = hd(first_article.tags)

          # Test lowercase
          articles =
            tag
            |> String.downcase()
            |> Blog.get_articles_by_tag()

          assert Enum.any?(articles, fn article ->
                   Enum.any?(article.tags, &(String.downcase(&1) == String.downcase(tag)))
                 end)

          # Test uppercase
          other_articles =
            tag
            |> String.upcase()
            |> Blog.get_articles_by_tag()

          assert Enum.any?(other_articles, fn article ->
                   Enum.any?(article.tags, &(String.downcase(&1) == String.downcase(tag)))
                 end)
        end
      end
    end

    test "returns empty list for non-existent tag" do
      articles = Blog.get_articles_by_tag("non-existent-tag-12345")
      assert articles == []
    end
  end

  describe "get_article_by_slug/1" do
    test "returns article with matching slug" do
      all_articles = Blog.all_articles()

      if length(all_articles) > 0 do
        first_article = hd(all_articles)
        found_article = Blog.get_article_by_slug(first_article.slug)

        assert found_article == first_article
      end
    end

    test "returns nil for non-existent slug" do
      article = Blog.get_article_by_slug("non-existent-slug-12345")
      assert article == nil
    end
  end

  describe "recent_articles/1" do
    test "returns the specified number of recent articles" do
      count = 2
      recent = Blog.recent_articles(count)
      all_articles = Blog.all_articles()

      expected_count = min(count, length(all_articles))
      assert length(recent) == expected_count

      if length(all_articles) >= count do
        assert recent == Enum.take(all_articles, count)
      end
    end

    test "defaults to 3 articles when no count specified" do
      recent = Blog.recent_articles()
      all_articles = Blog.all_articles()

      expected_count = min(3, length(all_articles))
      assert length(recent) == expected_count
    end
  end
end
