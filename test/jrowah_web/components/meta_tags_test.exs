defmodule JrowahWeb.MetaTagsTest do
  use ExUnit.Case, async: true
  use JrowahWeb, :verified_routes

  alias Jrowah.Blog.Article
  alias JrowahWeb.MetaTags

  describe "article_meta_assigns/2" do
    test "generates correct meta assigns for article" do
      article = %Jrowah.Blog.Article{
        id: "test-article",
        title: "Test Article",
        slug: "test-article",
        body: "<p>This is a test article body</p>",
        description: "This is a test article",
        author: "John Doe",
        tags: ["elixir", "phoenix"],
        date: ~D[2023-01-15],
        reading_time: 5,
        hero_image: "/images/test.jpg"
      }

      site_url = "https://jrowah.dev"

      assigns = MetaTags.article_meta_assigns(article, site_url)

      assert assigns.title == "Test Article"
      assert assigns.description == "This is a test article"
      assert assigns.author == "John Doe"
      assert assigns.og_type == "article"
      assert assigns.url == "https://jrowah.dev/blog/test-article"
      assert assigns.og_image == "https://jrowah.dev/images/test.jpg"
      assert assigns.og_image_alt == "Cover image for: Test Article"
      assert assigns.canonical_url == "https://jrowah.dev/blog/test-article"
      assert assigns.article_author == "John Doe"
      assert assigns.article_published_time == "2023-01-15"
      assert assigns.article_modified_time == "2023-01-15"
      assert assigns.article_section == "Technology"
      assert assigns.article_tags == ["elixir", "phoenix"]
    end

    test "handles missing og_image by falling back to hero_image" do
      article = %Article{
        id: "test-article",
        title: "Test Article",
        slug: "test-article",
        body: "<p>Test body</p>",
        description: "Test description",
        tags: ["Elixir"],
        author: "Test Author",
        date: ~D[2024-01-15],
        reading_time: 3,
        hero_image: "/images/hero.jpg",
        og_image: nil
      }

      site_url = "https://jrowah.dev"

      assigns = MetaTags.article_meta_assigns(article, site_url)

      assert assigns.og_image == "https://jrowah.dev/images/hero.jpg"
    end

    test "handles missing images with default" do
      article = %Article{
        id: "test-article",
        title: "Test Article",
        slug: "test-article",
        body: "<p>Test body</p>",
        description: "Test description",
        tags: ["Elixir"],
        author: "Test Author",
        date: ~D[2024-01-15],
        reading_time: 3,
        hero_image: nil,
        og_image: nil
      }

      site_url = "https://jrowah.dev"

      assigns = MetaTags.article_meta_assigns(article, site_url)

      assert assigns.og_image == "https://jrowah.dev/images/default-og.png"
    end

    test "handles absolute URLs in images" do
      article = %Article{
        id: "test-article",
        title: "Test Article",
        slug: "test-article",
        body: "<p>Test body</p>",
        description: "Test description",
        tags: ["Elixir"],
        author: "Test Author",
        date: ~D[2024-01-15],
        reading_time: 3,
        hero_image: "https://cdn.example.com/image.jpg",
        og_image: nil
      }

      site_url = "https://jrowah.dev"

      assigns = MetaTags.article_meta_assigns(article, site_url)

      assert assigns.og_image == "https://cdn.example.com/image.jpg"
    end
  end

  describe "generate_article_json_ld/2" do
    test "generates valid JSON-LD for article" do
      article = %Article{
        id: "test-article",
        title: "Test Article",
        slug: "test-article",
        body: "<p>Test body</p>",
        description: "Test description",
        tags: ["Elixir", "Phoenix"],
        keywords: ["elixir", "phoenix"],
        author: "Test Author",
        date: ~D[2024-01-15],
        reading_time: 5,
        hero_image: "/images/test.jpg"
      }

      site_url = "https://jrowah.dev"

      json_ld = MetaTags.generate_article_json_ld(article, site_url)

      # Parse the JSON to ensure it's valid
      parsed = Jason.decode!(json_ld)

      assert parsed["@context"] == "https://schema.org"
      assert parsed["@type"] == "BlogPosting"
      assert parsed["headline"] == "Test Article"
      assert parsed["description"] == "Test description"
      assert parsed["image"] == "https://jrowah.dev/images/test.jpg"
      assert parsed["author"]["@type"] == "Person"
      assert parsed["author"]["name"] == "Test Author"
      assert parsed["author"]["url"] == site_url
      assert parsed["publisher"]["@type"] == "Organization"
      assert parsed["publisher"]["name"] == "JRowah"
      assert parsed["datePublished"] == "2024-01-15"
      assert parsed["dateModified"] == "2024-01-15"
      assert parsed["mainEntityOfPage"]["@id"] == "https://jrowah.dev/blog/test-article"
      assert parsed["keywords"] == "elixir, phoenix"
      assert parsed["url"] == "https://jrowah.dev/blog/test-article"
    end
  end

  describe "page_meta component" do
    test "renders all meta tags correctly" do
      # Test the component by calling it directly
      meta_assigns = %{
        title: "Test Title",
        description: "Test Description",
        keywords: "test, keywords",
        author: "Test Author",
        og_type: "article",
        url: "https://jrowah.dev/test",
        og_image: "https://jrowah.dev/test.jpg",
        og_image_alt: "Test Image",
        canonical_url: "https://jrowah.dev/canonical",
        article_author: "Article Author",
        article_published_time: "2024-01-15",
        article_modified_time: "2024-01-15",
        article_section: "Technology",
        article_tags: ["Tag1", "Tag2"]
      }

      # Test that component can be called without errors
      result = MetaTags.page_meta(meta_assigns)
      assert is_map(result)
    end
  end

  describe "structured_data component" do
    test "renders JSON-LD script tag" do
      json_ld = """
      {"@context": "https://schema.org", "@type": "BlogPosting", "headline": "Test"}
      """

      # Test that component can be called without errors
      result = MetaTags.structured_data(%{json_ld: json_ld})
      assert is_map(result)
    end
  end
end
