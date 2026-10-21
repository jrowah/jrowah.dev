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
      <div class={[
        "journey-card-left relative bg-gray-500 p-3 rounded-xl my-2 ml-auto shadow-md md:self-start",
        @class
      ]}>
        <span
          aria-hidden="true"
          class="absolute -right-[52px] top-6 hidden h-6 w-6 rounded-full bg-blue-500 shadow md:block"
        ></span>
        <h1 class="text-sm">{@period}</h1>
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
      <div class="journey-card-right relative bg-gray-500 col-start-6 col-end-10 p-3 rounded-xl my-2 md:mt-8 mr-auto shadow-md md:self-start">
        <span
          aria-hidden="true"
          class="absolute -left-[52px] top-6 hidden h-6 w-6 rounded-full bg-blue-500 shadow md:block"
        ></span>
        <h1 class="text-sm">{@period}</h1>
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
end
