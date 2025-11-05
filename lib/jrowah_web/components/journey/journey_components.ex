defmodule JrowahWeb.Journey.JourneyComponents do
  @moduledoc """
  for each role

  """

  use Gettext, backend: JrowahWeb.Gettext
  use Phoenix.Component
  use JrowahWeb, :verified_routes

  attr :title, :string, default: nil
  attr :period, :string, default: nil
  attr :class, :string, default: nil
  attr :reverse?, :boolean, default: true
  attr :src, :string, required: true
  attr :company, :string, required: true
  attr :company_link, :string, required: true

  slot :inner_block

  @spec left_step(map()) :: Phoenix.LiveView.Rendered.t()
  def left_step(assigns) do
    ~H"""
    <div class="flex md:contents flex-row-reverse">
      <div class={["bg-gray-500 p-4 rounded-xl my-4 ml-auto shadow-md", @class]}>
        <h1>{@period}</h1>
        <hr />
        <h2 class="font-semibold text-lg mb-1">{@title}</h2>
        <h3 class="font-semibold text-lg mb-1">
          <a href={@company_link} target="_blank" rel="noopener noreferrer">
            <img class="w-20" src={@src} alt={[@company <> " logo"]} />
            <span>{@company}</span>
          </a>
        </h3>
        <h4>Tech Stack</h4>
        {render_slot(@inner_block)}
      </div>
      <.line_tracker />
    </div>
    """
  end

  attr :title, :string, default: nil
  attr :period, :string, default: nil
  attr :class, :string, default: nil
  attr :reverse?, :boolean, default: true
  attr :src, :string, required: true
  attr :company, :string, required: true
  attr :company_link, :string, required: true

  slot :inner_block

  @spec right_step(map()) :: Phoenix.LiveView.Rendered.t()
  def right_step(assigns) do
    ~H"""
    <div class="flex md:contents">
      <.line_tracker />
      <div class="bg-gray-500 col-start-6 col-end-10 p-4 rounded-xl my-4 mr-auto shadow-md">
        <h1>{@period}</h1>
        <hr />
        <h2 class="font-semibold text-lg mb-1">
          {@title}
        </h2>
        <h3 class="font-semibold text-lg mb-1">
          <a href={@company_link} target="_blank" rel="noopener noreferrer">
            <img class="w-20" src={@src} alt={[@company <> " logo"]} />
            <span>{@company}</span>
          </a>
        </h3>
        <h4>Tech Stack:</h4>
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  defp line_tracker(assigns) do
    ~H"""
    <div class="col-start-5 col-end-6 mr-10 md:mx-auto relative">
      <div class="h-full w-6 flex items-center justify-center">
        <div class="h-full w-[1px] bg-blue-800 pointer-events-none"></div>
      </div>
      <div class="w-6 h-6 absolute top-1/2 -mt-3 rounded-full bg-blue-500 shadow"></div>
    </div>
    """
  end
end
