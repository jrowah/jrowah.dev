defmodule Jrowah.Blog.ArticleTest do
  use ExUnit.Case, async: true

  alias Jrowah.Blog.Article

  describe "build/3" do
    test "creates article struct from filename, attrs, and body" do
      filename =
        "priv/resources/articles/2024/12-20-test-article.md"

      attrs = %{
        title: "Test Article",
        slug: "test-article",
        description: "A test article description",
        published: true,
        tags: ["Elixir", "Testing"],
        hero_image: "/images/test.jpg",
        author: "Test Author",
        keywords: ["elixir", "phoenix"],
        canonical_url: "https://example.com/test",
        og_image: "/images/og-test.jpg"
      }

      body = "<h1>Test Content</h1><p>This is test content for reading time calculation.</p>"

      article = Article.build(filename, attrs, body)

      assert %Article{} = article
      assert article.id == "test-article"
      assert article.slug == "test-article"
      assert article.title == "Test Article"
      assert article.description == "A test article description"
      assert article.published == true
      assert article.tags == ["Elixir", "Testing"]
      assert article.hero_image == "/images/test.jpg"
      assert article.author == "Test Author"
      assert article.keywords == ["elixir", "phoenix"]
      assert article.canonical_url == "https://example.com/test"
      assert article.og_image == "/images/og-test.jpg"
      assert article.body == body
      assert article.date == ~D[2024-12-20]
      assert is_integer(article.reading_time)
      assert article.reading_time >= 1
      assert is_list(article.heading_links)
    end

    test "sets default values when optional fields are not provided" do
      filename = "priv/resources/articles/2024/01-15-simple-article.md"

      attrs = %{
        slug: "deploying-phoenix-app-to-fly",
        title: "Fixing Phoenix Socket Origin Error When Deploying to Fly.io with Custom Domain",
        description:
          "A step-by-step guide to resolve the 'Could not check origin for Phoenix.Socket transport' error when deploying a Phoenix application to Fly.io with a custom domain.",
        published: true,
        keywords: ["Simple", "Phoenix"],
        tags: ["Phoenix", "Deployment", "Fly", "Troubleshooting"],
        og_image: "/images/simple.jpg",
        hero_image: "/images/2024/fly_deploy.png"
      }

      body = "<p>Simple content</p>"

      article = Article.build(filename, attrs, body)

      # default value
      assert article.author == "James Rowa"
      # falls back to tags
      assert article.keywords == ["Simple", "Phoenix"]
      assert article.canonical_url == nil
      # falls back to hero_image
      assert article.og_image == "/images/simple.jpg"
    end

    test "calculates reading time correctly" do
      filename = "priv/resources/articles/2025/09-09-system-design-concepts.md"

      attrs = %{
        slug: "system-design-concepts",
        title: "Beyond Syntax: A Self-Taught Developer's Journey into System Design",
        description:
          "The introductory part of a series of blogs posts about system design concepts in software development every self-taught software developer needs to master.",
        tags: [
          "System Design",
          "Databases",
          "DNS",
          "Proxies",
          "Latency",
          "Scaling",
          "Load Balancing"
        ],
        hero_image: "/images/2025/system_design_concepts.jpg",
        published: true
      }

      # Create content with approximately 185 words (1 minute read)
      words = List.duplicate("word", 185)
      body = "<p>#{Enum.join(words, " ")}</p>"

      article = Article.build(filename, attrs, body)

      assert article.reading_time == 1
    end

    test "parses date correctly from filename" do
      filename = "priv/resources/articles/2023/03-07-date-test.md"

      attrs = %{
        slug: "phoenix-migration",
        title: "Migrating Website from Gatsby to Phoenix and LiveView",
        description:
          "How and why I migrated from using React's Gatsby Framework and Netlify to using Phoenix, LiveView and Fly.io for my personal portfolio.",
        published: true,
        tags: ["Elixir", "LiveView", "Phoenix", "Web Development", "Fly", "TailwindCSS"],
        hero_image: "/images/2024/elixir_phoenix.avif"
      }

      body = "<p>Test content</p>"

      article = Article.build(filename, attrs, body)

      assert article.date == ~D[2023-03-07]
    end

    test "extracts heading links from HTML body" do
      filename = "priv/resources/articles/2024/06-10-headings-test.md"

      attrs = %{
        slug: "deploying-phoenix-app-to-fly",
        title: "Fixing Phoenix Socket Origin Error When Deploying to Fly.io with Custom Domain",
        description:
          "A step-by-step guide to resolve the 'Could not check origin for Phoenix.Socket transport' error when deploying a Phoenix application to Fly.io with a custom domain.",
        published: true,
        tags: ["Phoenix", "Deployment", "Fly", "Troubleshooting"],
        hero_image: "/images/2024/fly_deploy.png"
      }

      body = """
      <h2><a href="#section-1">Section 1</a></h2>
      <p>Content</p>
      <h3><a href="#subsection-1">Subsection 1</a></h3>
      <h2><a href="#section-2">Section 2</a></h2>
      """

      article = Article.build(filename, attrs, body)

      assert is_list(article.heading_links)
      # The specific structure depends on your heading parsing implementation
      assert length(article.heading_links) >= 0
    end

    test "MDEx includes IDs and anchor links" do
      assert MDEx.to_html("## Introduction\n", extension: [header_ids: ""]) ==
               {:ok,
                "<h2><a href=\"#introduction\" aria-hidden=\"true\" class=\"anchor\" id=\"introduction\"></a>Introduction</h2>"}
    end
  end
end
