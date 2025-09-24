defmodule JrowahWeb.TableOfContents do
  @moduledoc """
  Table of contents component for blog articles
  """

  use Phoenix.Component

  @doc """
  Renders a table of contents from a list of headings.

  ## Examples

      <.toc headings={@article.heading_links} />
      <.toc headings={@article.heading_links} class="custom-toc-class" />
  """
  attr :headings, :list, required: true
  attr :class, :string, default: "toc-list"

  @spec toc(map()) :: Phoenix.LiveView.Rendered.t()
  def toc(assigns) do
    ~H"""
    <ul class={@class}>
      <li :for={%{label: label, href: href, children: children} <- @headings}>
        <.link href={href} class="toc-link">
          <%= label %>
        </.link>
        <.toc :if={children != []} headings={children} class="toc-list toc-nested" />
      </li>
    </ul>
    """
  end
end
