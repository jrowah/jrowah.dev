defmodule Jrowah.Blog.Article do
  @moduledoc """
  A resource representing a blog article
  """

  @words_per_minute 185
  @enforce_keys [:id, :slug, :title, :body, :description, :tags, :date, :reading_time]
  defstruct id: "",
            slug: "",
            title: "",
            reading_time: 0,
            body: "",
            description: "",
            tags: [],
            date: nil,
            heading_links: [],
            published: false

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
    heading_links = parse_headings(body)

    struct!(
      __MODULE__,
      [id: id, date: date, body: body, reading_time: reading_time, heading_links: heading_links] ++
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

  defp parse_headings(body) do
    body
    |> Floki.parse_fragment!()
    |> reducer()
    |> Enum.reverse()
    |> Enum.map(fn %{children: children} = h2 -> %{h2 | children: Enum.reverse(children)} end)
  end

  defp reducer(html) do
    Enum.reduce(html, [], fn
      {"h2", _class, child} = el, acc ->
        [%{label: Floki.text(el), href: get_heading_link(child), children: []} | acc]

      {"h3", _class, child} = el, [%{children: subs} = h2 | rest] ->
        [
          %{
            h2
            | children: [
                %{label: Floki.text(el), href: get_heading_link(child), children: []} | subs
              ]
          }
          | rest
        ]

      _other, acc ->
        acc
    end)
  end

  defp get_heading_link(heading) do
    attr =
      heading
      |> Floki.find("a")
      |> Floki.attribute("href")

    case attr do
      [] -> nil
      [link] -> link
    end
  end
end
