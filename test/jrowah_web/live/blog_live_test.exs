defmodule JrowahWeb.BlogLiveTest do
  use JrowahWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias Jrowah.Blog

  describe "/blog" do
    test "renders blog page", %{conn: conn} do
      {:ok, _blog_live, html} = live(conn, "/blog")

      assert html =~
               "In these blogs you&#39;ll find in-depth posts on mastering emerging tools, real-world problem-solving, reflections on growth, and a few basic tips and topics for those who are just getting started."
    end

    test "has nav links that are clickable and navigate to the correct pages", %{conn: conn} do
      {:ok, _blog_live, html} = live(conn, "/blog")

      assert html =~ "Home"
      assert html =~ "href=\"/\""

      assert html =~ "Blog"
      assert html =~ "href=\"/blog\""

      assert html =~ "Projects"
      assert html =~ "href=\"/projects\""
    end

    test "has links to other social media", %{conn: conn} do
      {:ok, _blog_live, html} = live(conn, "/blog")

      assert html =~ "GitHub"
      assert html =~ "href=\"https://github.com/jrowah\""

      assert html =~ "LinkedIn"
      assert html =~ "href=\"https://www.linkedin.com/in/james-rowa/\""

      assert html =~ "Twitter"
      assert html =~ "href=\"https://twitter.com/jrowah\""

      # assert html =~ "Email"
      # assert html =~ "href=\"mailto:JlQpW@example.com\""
    end

    test "clicking the journey link takes you to the journey page", %{conn: conn} do
      {:ok, blog_live, _html} = live(conn, "/blog")

      assert {:error, {:live_redirect, %{kind: :push, to: "/journey"}}} =
               blog_live
               |> element(~s|.desktop-journey-link|)
               |> render_click()
    end

    test "clicking the projects link takes you to the projects page", %{conn: conn} do
      {:ok, blog_live, _html} = live(conn, "/blog")

      assert {:error, {:live_redirect, %{kind: :push, to: "/projects"}}} =
               blog_live
               |> element(~s|.desktop-projects-link|)
               |> render_click()
    end

    test "clicking the home link takes you to the blog page", %{conn: conn} do
      {:ok, blog_live, _html} = live(conn, "/blog")

      assert {:error, {:live_redirect, %{kind: :push, to: "/"}}} =
               blog_live
               |> element(~s|.desktop-home-link|)
               |> render_click()

      # TODO: Test the newly rendered liveview
    end

    test "disconnected and connected render", %{conn: conn} do
      {:ok, page_live, disconnected_html} = live(conn, "/blog")
      assert disconnected_html =~ "Blog"
      assert render(page_live) =~ "Blog"
    end
  end

  describe "/blog/:slug" do
    test "renders individual blog article", %{conn: conn} do
      articles = Blog.all_articles()

      if length(articles) > 0 do
        article = hd(articles)
        {:ok, _show_live, html} = live(conn, "/blog/#{article.slug}")

        assert html =~ article.title
        # Check for description content in the page (not in meta tags)
        assert html =~ ~r/Part Two of the.*Beyond Syntax.*System Design/
        assert html =~ "Back to all articles"
      end
    end

    test "includes proper meta tags for SEO", %{conn: conn} do
      articles = Blog.all_articles()

      if length(articles) > 0 do
        article = hd(articles)
        conn = get(conn, "/blog/#{article.slug}")
        html = html_response(conn, 200)

        # Check for basic meta tags
        assert html =~
                 ~s(name="title" content="#{article.title}")

        # Check for description meta tag with HTML-encoded content
        assert html =~
                 ~r/name="description" content="Part Two of the.*Beyond Syntax.*System Design.*"/

        assert html =~ ~s(name="author" content="#{article.author}")

        # Check for Open Graph tags
        assert html =~ ~s(property="og:type" content="article")

        assert html =~
                 ~s(property="og:title" content="#{article.title}")

        # Check for Open Graph description with HTML-encoded content
        assert html =~
                 ~r/property="og:description" content="Part Two of the.*Beyond Syntax.*System Design.*"/

        # Check for Twitter tags
        assert html =~ ~s(property="twitter:card" content="summary_large_image")

        assert html =~
                 ~s(property="twitter:title" content="#{article.title}")

        # Check for structured data
        assert html =~ ~s(type="application/ld+json")
        assert html =~ ~s(\"@type\":\"BlogPosting\")

        assert html =~
                 ~s(\"headline\":\"#{article.title}\")
      end
    end

    test "handles non-existent article slugs", %{conn: conn} do
      {:error, {:live_redirect, %{to: "/blog", flash: %{"error" => "Article not found"}}}} =
        live(conn, "/blog/non-existent-slug-12345")
    end

    test "displays article metadata correctly", %{conn: conn} do
      articles = Blog.all_articles()

      if length(articles) > 0 do
        article = hd(articles)
        {:ok, _show_live, html} = live(conn, "/blog/#{article.slug}")

        # Check for publication date
        formatted_date = Calendar.strftime(article.date, "%d %B %Y")
        assert html =~ formatted_date

        # Check for reading time
        assert html =~ "#{article.reading_time} min read"

        # Check for hero image if present
        if article.hero_image do
          assert html =~ ~s(src="#{article.hero_image}")
        end
      end
    end

    test "includes share functionality", %{conn: conn} do
      articles = Blog.all_articles()

      if length(articles) > 0 do
        article = hd(articles)
        {:ok, _show_live, html} = live(conn, "/blog/#{article.slug}")

        # Check for share button
        assert html =~ "hero-share"
        assert html =~ "Copy link"
      end
    end
  end
end
