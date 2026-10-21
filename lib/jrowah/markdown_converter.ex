defmodule Jrowah.MarkdownConverter do
  @moduledoc """
  A markdown converter for Jrowah
  """

  @spec convert(String.t(), String.t(), map(), map()) :: String.t()
  def convert(_filepath, body, _attrs, _opts) do
    MDEx.to_html!(body, extension: [header_id_prefix: ""], parse: [smart: true])
  end
end
