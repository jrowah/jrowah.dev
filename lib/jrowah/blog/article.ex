defmodule Jrowah.Blog.Article do
  @moduledoc """
  A resource representing a blog article
  """

  @words_per_minute 185
  @enforce_keys [
    :id,
    :slug,
    :title,
    :body,
    :description,
    :tags,
    :date,
    :reading_time,
    :hero_image
  ]
  defstruct id: "",
            slug: "",
            title: "",
            reading_time: 0,
            body: "",
            description: "",
            tags: [],
            previous_article_slug: "",
            next_article_slug: "",
            date: nil,
            heading_links: [],
            hero_image: "",
            published: false,
            author: "",
            keywords: [],
            canonical_url: nil,
            og_image: nil

  @type t :: %__MODULE__{}

  @spec build(String.t(), map(), String.t()) :: %__MODULE__{}
  def build(filename, attrs, body) do
    [year, month_day_id] =
      filename
      |> Path.rootname()
      |> Path.split()
      |> Enum.take(-2)

    [month, day, id] = String.split(month_day_id, "-", parts: 3)
    date = Date.from_iso8601!("#{year}-#{month}-#{day}")

    reading_time = calculate_reading_time(body)

    heading_links =
      body
      |> parse_headings()
      |> Enum.map(fn h2 -> %{h2 | children: Enum.reverse(h2.children)} end)
      |> Enum.reverse()

    struct!(
      __MODULE__,
      [
        author: "James Rowa",
        id: id,
        date: date,
        body: body,
        reading_time: reading_time,
        heading_links: heading_links,
        hero_image: attrs["hero_image"],
        description: attrs["description"]
      ] ++
        Map.to_list(attrs)
    )
  end

  defp calculate_reading_time(html) do
    word_count =
      html
      |> Floki.parse_fragment!()
      |> Floki.text()
      |> String.split()
      |> Enum.count()

    case div(word_count, @words_per_minute) do
      0 -> 1
      n -> n
    end
  end

  defp parse_headings(content) do
    content
    |> Floki.parse_fragment!()
    |> Enum.reduce([], fn
      {"h2", _class, child} = el, acc ->
        [%{label: Floki.text(el), href: get_href(child), children: []} | acc]

      {"h3", _class, child} = el, acc ->
        case acc do
          [%{children: subs} = h2 | rest] ->
            updated_h2 = %{
              h2
              | children: [%{label: Floki.text(el), href: get_href(child), children: []} | subs]
            }

            [updated_h2 | rest]

          [] ->
            acc
        end

      _other, acc ->
        acc
    end)
  end

  defp get_href(heading_element) do
    attr =
      heading_element
      |> Floki.find("a")
      |> Floki.attribute("href")

    case attr do
      [] -> nil
      [href | _other] -> href
    end
  end
end
