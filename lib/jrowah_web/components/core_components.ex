defmodule JrowahWeb.CoreComponents do
  @moduledoc """
  Provides core UI components.

  At first glance, this module may seem daunting, but its goal is to provide
  core building blocks for your application, such as modals, tables, and
  forms. The components consist mostly of markup and are well-documented
  with doc strings and declarative assigns. You may customize and style
  them in any way you want, based on your application growth and needs.

  The default components use Tailwind CSS, a utility-first CSS framework.
  See the [Tailwind CSS documentation](https://tailwindcss.com) to learn
  how to customize them or feel free to swap in another framework altogether.

  Icons are provided by [heroicons](https://heroicons.com). See `icon/1` for usage.
  """
  use Gettext, backend: JrowahWeb.Gettext
  use Phoenix.Component
  use JrowahWeb, :verified_routes

  import Phoenix.HTML

  alias Phoenix.HTML.Form
  alias Phoenix.LiveView.JS

  @doc """
  Renders an avatar.

  ## Examples

      <.avatar />

  """
  @spec avatar(map()) :: Phoenix.LiveView.Rendered.t()
  def avatar(assigns) do
    ~H"""
    <.link navigate={~p"/"} class="avatar cursor-pointer">
      <img
        loading="lazy"
        src="https://avatars.githubusercontent.com/u/76947107?s=400&u=cd0be7843d2c30ae6f985634ac9966b11242aacb&v=4"
        alt="Jrowah's Portrait"
        class="w-10 h-10 rounded-full"
      />
    </.link>
    """
  end

  defp theme_button(assigns) do
    ~H"""
    <button
      id="theme-toggle"
      type="button"
      phx-update="ignore"
      phx-hook="DarkThemeToggle"
      class="text-zinc-500 dark:text-zinc-400 hover:bg-zinc-100 dark:hover:bg-zinc-700 rounded-lg text-sm p-2"
    >
      <span id="theme-toggle-dark-icon" class="hidden">
        <.icon name="hero-moon-solid" class="w-6 h-6 text-blue-400" />
      </span>
      <span id="theme-toggle-light-icon">
        <.icon name="hero-sun-solid" class="w-6 h-6 text-blue-400" />
      </span>
    </button>
    """
  end

  @doc """
  Renders the page intro.
  """
  attr :title, :string, default: nil
  attr :class, :string, default: nil
  attr :extended_title, :string, default: nil
  slot :inner_block

  @spec page_intro(map()) :: Phoenix.LiveView.Rendered.t()
  def page_intro(assigns) do
    ~H"""
    <.title
      :if={@title}
      text={@title}
      extended_text={@extended_title}
      class="text-blue-600 dark:text-blue-500 text-3xl md:text-4xl"
    />
    <div class={[@inner_block != [] && "text-pretty my-4 leading-relaxed md:my-6", @class]}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  @doc """
  Renders a title.
  """
  attr :text, :string, required: true
  attr :class, :string, default: nil
  attr :extended_text, :string

  @spec title(map()) :: Phoenix.LiveView.Rendered.t()
  def title(assigns) do
    ~H"""
    <h1 class={["text-3xl font-semibold", @class]}>
      <%= @text %>
      <span class="from-pink-600 to-blue-800 bg-gradient-to-r bg-clip-text text-transparent">
        <%= @extended_text %>
      </span>
    </h1>
    """
  end

  @doc """
  Renders a project card

  ## Examples

      <.project_card title="Project Title" description="Project Description" />

  """

  attr :title, :string, required: true
  attr :link, :string, required: true
  attr :link_label, :string, required: true
  attr :description, :string, required: true

  @spec project_card(map()) :: Phoenix.LiveView.Rendered.t()
  def project_card(assigns) do
    ~H"""
    <article class="project-card card p-4 group h-full w-full transition-all hover:-translate-y-1 hover:-bg-gray-300 shadow-xl dark:shadow-[0_4px_10px_rgba(255,255,255,0.5)]
    shadow-[0_4px_10px_rgba(0,0,0,0.2)]">
      <div class="card-body">
        <h2 class="text-bold text-pretty mb-4">
          <%= @title %>
        </h2>
        <p class="text-pretty mb-4">
          <%= @description %>
        </p>

        <div class="card-actions justify-end">
          <div class="flex items-center space-x-2">
            <.icon name="hero-link" class="text-content group-hover:text-primary" />
            <span class="text-content group-hover:text-primary group-hover:underline">
              <.link href={@link} target="_blank" class="text-blue-600"><%= @link_label %></.link>
            </span>
          </div>
        </div>
      </div>
    </article>
    """
  end

  @doc """
  Renders an article card

  ## Examples

      <.article_card
        title="Article Title"

        src="https://picsum.photos/seed/1/200/300"
        alt="Article Image"
        href="https://www.google.com"
      />


  """

  attr :title, :string, required: true
  attr :id, :string, default: nil
  attr :class, :string, default: nil
  attr :link, :string, required: true
  attr :description, :string, required: true
  attr :tags, :list, default: []
  attr :date, :any, required: true
  attr :reading_time, :integer, required: true

  @spec article_card(map()) :: Phoenix.LiveView.Rendered.t()
  def article_card(assigns) do
    ~H"""
    <.link id={@id} navigate={@link} rel="noopener noreferrer">
      <article class={[
        "card group h-full w-full cursor-pointer transition-all hover:-translate-y-1",
        @class
      ]}>
        <div class="article-card">
          <h2 class="card-title text-pretty mb-4 text-blue-400 md:text-2xl">
            <%= @title %>
          </h2>
          <hr class="border border-gray-600 dark:border-white mb-2" />
          <%!-- <hr class="bg-gray-900 dark:bg-white" /> --%>
          <div class="mb-4 flex w-fit items-center">
            <span class="text-xs font-semibold">
              <%= Calendar.strftime(@date, "%d %B %Y") %>
            </span>
            <span class="bg-base-content mx-2 h-px w-4 flex-1 opacity-20" />
            <span class="text-xs font-semibold">
              <%= @reading_time %> min read
            </span>
          </div>
          <div :if={@tags != []} class="mb-4 flex flex-wrap gap-x-2 gap-y-2">
            <span
              :for={tag <- @tags}
              class="bg-gray-200 dark:bg-zinc-700 rounded-lg px-2 py-1 transition-transform duration-100 hover:scale-105"
            >
              <%= case tag do %>
                <% "Elixir" -> %>
                  <span class="text-[#BA68C8]">Elixir</span>
                <% "Phoenix" -> %>
                  <span class="text-[#F4511E]">Phoenix</span>
                <% "LiveView" -> %>
                  <span class="from-orange-400 to-blue-500 bg-gradient-to-r bg-clip-text text-transparent">
                    LiveView
                  </span>
                <% "Ecto" -> %>
                  <span class="text-[#66BB6A]">Ecto</span>
                <% "TailwindCSS" -> %>
                  <span class="text-[#64B5F6]">TailwindCSS</span>
                <% _other -> %>
                  <%= tag %>
              <% end %>
            </span>
          </div>
          <p class="text-pretty mb-4">
            <%= @description %>
          </p>
          <div class="card-actions justify-end">
            <div class="flex items-center space-x-2">
              <span class="text-content group-hover:text-primary group-hover:underline">
                Read more
              </span>
              <.icon name="hero-arrow-right" class="text-content group-hover:text-primary" />
            </div>
          </div>
        </div>
      </article>
    </.link>
    """
  end

  @doc """
  Renders blog tags

  ## Examples

      <.blog_tags
        tags={@tags}
      />

  """
  attr :id, :string, default: nil
  attr :tags, :list, required: true
  attr :search_tag, :string, default: nil
  attr :select_event, :string

  @spec blog_tags(map()) :: Phoenix.LiveView.Rendered.t()
  def blog_tags(assigns) do
    ~H"""
    <section id={@id} class="mx-2">
      <div class="flex flex-wrap gap-2">
        <button
          :for={tag <- @tags}
          phx-click="filter_by_tag"
          phx-value-tag={tag}
          class={[
            "rounded-lg px-2 py-1 transition-transform duration-100 hover:scale-105",
            (String.downcase(tag) == @search_tag && "bg-blue-500 dark:bg-blue-500 text-white") ||
              "bg-gray-200 dark:bg-zinc-700"
          ]}
        >
          <%= tag %>
        </button>
      </div>
    </section>
    """
  end

  @doc """
  Renders a navigation bar.

  ## Examples

      <.navbar current_url={@current_url}>
        <.link to="/">Home</.link>
      </.navbar>
  """

  attr :current_url, :string, required: true

  @spec navbar(map()) :: Phoenix.LiveView.Rendered.t()
  def navbar(assigns) do
    ~H"""
    <nav class="flex h-[80px] bg-white dark:bg-gray-800 w-full font-bold text-sm md:text-base lg:text-lg text-blue-600 dark:text-blue-400">
      <div class="mx-auto flex w-full max-w-6xl items-center justify-between px-4">
        <.avatar />

        <div class="ml-auto">
          <div class="bg-base-300 hidden space-x-4 px-4 py-2 sm:block">
            <.link
              :for={
                %{label: label, unique_class: unique_class, route: route} <-
                  main_nav_links()
              }
              navigate={route}
              class={[
                unique_class,
                active?(@current_url, route) && "border-b-2 border-current pb-2"
              ]}
            >
              <span class="inline-flex items-center justify-center text-center bg-blue-500 h-6 w-6 rounded-full text-white">
                <.icon name={nav_icon_names(label)} class="w-4 h-4" />
              </span>
              <%= label %>
            </.link>
          </div>

          <.mobile_navigation_modal id="mobile_navigation_modal" header="Navigation">
            <nav class="mt-4 flex flex-col space-y-4">
              <.link
                :for={%{label: label, route: route} <- main_nav_links()}
                navigate={route}
                class={[
                  active?(@current_url, route) && "underline underline-offset-8"
                ]}
              >
                <%= label %>
              </.link>
            </nav>
          </.mobile_navigation_modal>

          <div class="rounded-btn bg-base-300 block p-2 sm:hidden">
            <button
              class="btn-sm flex items-center font-semibold"
              phx-click={show_modal("mobile_navigation_modal")}
            >
              <span><.icon name="hero-bars-3-solid" class="h-5 w-5" /></span>
            </button>
          </div>
        </div>

        <.theme_button />
      </div>
    </nav>
    """
  end

  defp nav_icon_names(label) do
    case label do
      "Home" -> "hero-home-solid"
      "About" -> "hero-user-solid"
      "Blog" -> "hero-pencil-square-solid"
      "Projects" -> "hero-folder-solid"
      "Journey" -> "hero-arrow-trending-up-solid"
    end
  end

  @spec footer(map()) :: Phoenix.LiveView.Rendered.t()
  def footer(assigns) do
    ~H"""
    <footer class={[
      "flex flex-col inset-x-0 footer footer-center absolute w-full max-w-[1260px] px-4 sm:px-6 lg:px-8 mx-auto h-[15%]",
      URI.parse(@current_url).path in ["/privacy-policy", "/legal-terms", "/cookies-policy"] &&
        "hidden"
    ]}>
      <hr />
      <div class="flex justify-between px-10 py-5 bg-base-200 text-base-content text-blue-600 dark:text-blue-400">
        <div class="flex flex-col">
          <span>Copyright © Jrowah 2024</span>
          <.link navigate={~p"/privacy-policy"} target="_blank">
            Privacy Policy
          </.link>
          <.link navigate={~p"/cookies-policy"} target="_blank">
            Cookies Policy
          </.link>
          <.link navigate={~p"/legal-terms"} target="_blank">
            Terms and Conditions
          </.link>
        </div>
        <div class="md:w-[20%]">
          <p class="md:text-right font-bold text-lg">Find Me On</p>
          <div class="flex justify-between">
            <.link
              :for={%{label: label, link: link, svg: svg} <- social_links()}
              href={link}
              target="_blank"
              class="text-black dark:text-white"
            >
              <span class="hidden md:block"><%= label %></span>
              <%= raw(svg) %>
            </.link>
          </div>
        </div>
      </div>
    </footer>
    """
  end

  @doc """
  Renders a list of skills

  ## Examples

      <.skillset years={3} months={5} />
  """

  attr :years, :integer, required: true
  attr :months, :integer, required: true

  @spec skillset(map()) :: Phoenix.LiveView.Rendered.t()
  def skillset(assigns) do
    ~H"""
    <ul class="pl-5 my-2 text-green-800 dark:text-blue-400">
      <li>
        <div class="flex items-center mb-1">
          <span>
            <svg
              version="1.1"
              id="Layer_1"
              xmlns="http://www.w3.org/2000/svg"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              x="0px"
              y="0px"
              viewBox="0 0 89.28 122.88"
              style="enable-background:new 0 0 89.28 122.88"
              xml:space="preserve"
              class="w-6 h-6 fill-current text-blue-600 dark:text-white"
            >
              <g>
                <path
                  class="st0"
                  d="M2.86,82.1h9.65c3.1-4.81,9.75-7.32,15.7-9.57c1.47-0.56,2.9-1.09,4.2-1.64c0.69-0.91,1.25-1.88,1.69-2.93 c0.38-0.9,0.66-1.85,0.85-2.85c-1.06-0.63-2.08-1.38-3.05-2.24c-3.95-3.5-6.71-6.36-8.49-9.67c-1.81-3.36-2.56-7.08-2.46-12.26 l0.28-11.86c0-0.17,0.03-0.32,0.08-0.47l-3.49-1.2C17.32,16.04,23.72,9.22,31.63,5.79c2.89-1.25-1.95-7.55,4.69-5.32 c8.87,2.97,28.53,6.84,33.19,12.2c3.79,4.36,3.94,6.75,3.85,12.49c-0.03,1.86-0.32,3.5-1.21,4.1c-0.41,0.27-0.9,0.37-1.46,0.31 v12.46c0,7.1-2.54,13.03-6.44,17.43c-2.2,2.48-4.82,4.46-7.67,5.89c0.17,0.91,0.41,1.79,0.71,2.62c0.35,0.97,0.8,1.9,1.33,2.78 c1.14,0.51,2.27,0.97,3.4,1.43c5.56,2.28,11.21,4.59,14.13,9.91h10.1c1.86,0,3.37,1.85,2.94,4.11L83,118.77 c-0.42,2.22-1.85,4.11-4.11,4.11H11.46c-2.26,0-3.62-1.9-4.11-4.11L0.1,86.21C-0.4,83.95,1.06,82.1,2.86,82.1L2.86,82.1z M44.8,97.44c2.72,0,4.93,2.21,4.93,4.93s-2.21,4.93-4.93,4.93c-2.72,0-4.93-2.21-4.93-4.93S42.08,97.44,44.8,97.44L44.8,97.44z M40.16,67.29c-0.89-0.23-1.76-0.53-2.61-0.88c-0.21,0.91-0.5,1.79-0.85,2.64c-0.45,1.06-1.01,2.08-1.69,3.04 c0.75,0.83,1.59,1.54,2.51,2.13c2.48,1.6,5.46,2.35,8.4,2.28c2.92-0.07,5.77-0.96,8.01-2.65c0.77-0.59,1.47-1.27,2.07-2.04 c-0.52-0.91-0.97-1.87-1.33-2.88c-0.28-0.77-0.51-1.57-0.69-2.39c-2.86,1.02-5.75,1.53-8.58,1.49 C43.61,67.99,41.86,67.75,40.16,67.29L40.16,67.29z M37.25,63.15c0.92,0.49,1.87,0.88,2.83,1.2c1.8,0.56,3.69,0.84,5.58,0.84v0.01 c3,0,6.04-0.68,8.88-1.97c2.84-1.29,5.46-3.19,7.61-5.61c3.47-3.91,5.72-9.2,5.72-15.57v-9.86l0,0c-0.03-0.94-0.16-1.8-0.4-2.58 c-0.23-0.75-0.57-1.42-1.03-1.99c-1.72-2.15-3.35-2.13-5.68-2.12c-0.21,0-0.43,0-0.72,0c-9.21-0.03-15.24-0.33-20.14-0.99 c-4.52-0.61-8.06-1.52-12.18-2.82c-0.39,0.87-0.84,1.71-1.37,2.54c-0.67,1.05-1.46,2.05-2.35,3l-0.27,13.78 c-0.09,4.66,0.57,7.97,2.13,10.89c1.59,2.96,4.17,5.61,7.87,8.9c0.98,0.87,2.03,1.6,3.12,2.21C37.01,63.02,37.14,63.07,37.25,63.15 L37.25,63.15z M57.14,37.01c1.67,0,3.03,1.36,3.03,3.03c0,1.67-1.36,3.03-3.03,3.03c-1.67,0-3.03-1.36-3.03-3.03 C54.11,38.37,55.46,37.01,57.14,37.01L57.14,37.01z M34.28,37.01c1.67,0,3.03,1.36,3.03,3.03c0,1.67-1.36,3.03-3.03,3.03 c-1.67,0-3.03-1.36-3.03-3.03C31.25,38.37,32.61,37.01,34.28,37.01L34.28,37.01z M39.51,54.59c-0.65-0.42-0.83-1.29-0.41-1.94 c0.42-0.65,1.29-0.83,1.94-0.41c1.6,1.04,3.13,1.6,4.59,1.62c1.41,0.02,2.81-0.48,4.19-1.55c0.61-0.48,1.5-0.37,1.97,0.25 c0.48,0.61,0.37,1.49-0.25,1.97c-1.9,1.48-3.89,2.16-5.95,2.14C43.58,56.63,41.55,55.91,39.51,54.59L39.51,54.59z M16.08,82.1 h56.73c-2.7-3.57-7.31-5.46-11.85-7.32c-0.95-0.39-1.89-0.78-2.8-1.17c-0.76,1.03-1.68,1.92-2.72,2.68 c-2.51,1.82-5.75,2.87-9.1,3.03c-3.33,0.16-6.78-0.55-9.72-2.25c-1.47-0.84-2.81-1.93-3.94-3.26c-1.11,0.45-2.28,0.89-3.48,1.34 C24.39,76.97,19.1,78.97,16.08,82.1L16.08,82.1z"
                />
              </g>
            </svg>
          </span>
          <span class="ml-2 text-blue-600 text-lg">Skillset:</span>
        </div>
        <p class="ml-8 font-bold">
          Elixir, Phoenix, LiveView, Nodejs, ReactJS, GraphQL, SQL
        </p>
      </li>
      <li>
        <div class="flex items-center mb-1">
          <span>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              xml:space="preserve"
              version="1.1"
              shape-rendering="geometricPrecision"
              text-rendering="geometricPrecision"
              image-rendering="optimizeQuality"
              fill-rule="evenodd"
              clip-rule="evenodd"
              viewBox="0 0 512 512"
              class="w-6 h-6 fill-current text-blue-600 dark:text-white"
            >
              <path
                fill-rule="nonzero"
                d="M423.51 61.53c-5.02,-5.03 -10.92,-7.51 -17.75,-7.51 -6.82,0 -12.8,2.48 -17.75,7.51l-27.05 26.97c-7.25,-4.7 -14.93,-8.8 -22.95,-12.47 -8.02,-3.67 -16.22,-6.82 -24.5,-9.55l0 -41.48c0,-7 -2.38,-12.89 -7.25,-17.75 -4.86,-4.86 -10.75,-7.25 -17.75,-7.25l-52.05 0c-6.66,0 -12.45,2.39 -17.49,7.25 -4.95,4.86 -7.43,10.75 -7.43,17.75l0 37.98c-8.7,2.04 -17.15,4.6 -25.26,7.76 -8.19,3.16 -15.95,6.74 -23.29,10.75l-29.96 -29.53c-4.69,-4.94 -10.4,-7.5 -17.32,-7.5 -6.83,0 -12.71,2.56 -17.75,7.5l-36.43 36.54c-5.03,5.03 -7.51,10.92 -7.51,17.73 0,6.83 2.48,12.81 7.51,17.75l26.97 27.06c-4.7,7.26 -8.79,14.93 -12.46,22.95 -3.68,8.02 -6.83,16.22 -9.56,24.49l-41.47 0c-7.01,0 -12.9,2.39 -17.76,7.26 -4.86,4.86 -7.25,10.75 -7.25,17.75l0 52.05c0,6.65 2.39,12.46 7.25,17.5 4.86,4.94 10.75,7.42 17.76,7.42l37.97 0c2.04,8.7 4.6,17.15 7.76,25.25 3.17,8.2 6.75,16.13 10.75,23.81l-29.52 29.44c-4.95,4.7 -7.51,10.41 -7.51,17.33 0,6.82 2.56,12.71 7.51,17.75l36.53 36.95c5.03,4.69 10.92,7 17.75,7 6.82,0 12.79,-2.31 17.75,-7l27.04 -27.48c7.26,4.69 14.94,8.78 22.96,12.46 8.02,3.66 16.21,6.83 24.49,9.55l0 41.48c0,7 2.39,12.88 7.25,17.74 4.86,4.87 10.76,7.26 17.75,7.26l52.05 0c6.66,0 12.46,-2.39 17.5,-7.26 4.94,-4.86 7.42,-10.74 7.42,-17.74l0 -37.98c8.7,-2.04 17.15,-4.6 25.25,-7.76 8.2,-3.16 16.14,-6.74 23.81,-10.75l29.44 29.53c4.7,4.95 10.49,7.5 17.51,7.5 7.07,0 12.87,-2.55 17.57,-7.5l36.95 -36.53c4.69,-5.04 7,-10.92 7,-17.75 0,-6.82 -2.31,-12.8 -7,-17.75l-27.48 -27.05c4.7,-7.26 8.79,-14.93 12.46,-22.96 3.66,-8.01 6.83,-16.21 9.56,-24.49l41.47 0c7,0 12.88,-2.4 17.74,-7.25 4.87,-4.87 7.26,-10.75 7.26,-17.75l0 -52.05c0,-6.66 -2.39,-12.45 -7.26,-17.5 -4.86,-4.95 -10.74,-7.42 -17.74,-7.42l-37.98 0c-2.04,-8.36 -4.6,-16.73 -7.76,-25 -3.16,-8.37 -6.74,-16.21 -10.75,-23.56l29.53 -29.95c4.95,-4.69 7.5,-10.41 7.5,-17.32 0,-6.83 -2.55,-12.71 -7.5,-17.75l-36.53 -36.43zm-48.41 257.98c-22.72,42.52 -67.54,71.44 -119.1,71.44 -51.58,0 -96.37,-28.92 -119.09,-71.42 2.66,-11.61 7.05,-21.74 19.9,-28.84 17.76,-9.89 48.34,-9.15 62.89,-22.24l20.1 52.78 10.1 -28.77 -4.95 -5.42c-3.72,-5.44 -2.44,-11.62 4.46,-12.74 2.33,-0.37 4.95,-0.14 7.47,-0.14 2.69,0 5.68,-0.25 8.22,0.32 6.41,1.41 7.07,7.62 3.88,12.56l-4.95 5.42 10.11 28.77 18.18 -52.78c13.12,11.8 48.43,14.18 62.88,22.24 12.89,7.22 17.26,17.24 19.9,28.82zm-159.11 -86.45c-1.82,0.03 -3.31,-0.2 -4.93,-1.1 -2.15,-1.19 -3.67,-3.24 -4.7,-5.55 -2.17,-4.86 -3.89,-17.63 1.57,-21.29l-1.02 -0.66 -0.11 -1.41c-0.21,-2.57 -0.26,-5.68 -0.32,-8.95 -0.2,-12 -0.45,-26.56 -10.37,-29.47l-4.25 -1.26 2.81 -3.38c8.01,-9.64 16.38,-18.07 24.82,-24.54 9.55,-7.33 19.26,-12.2 28.75,-13.61 9.77,-1.44 19.23,0.75 27.97,7.62 2.57,2.03 5.08,4.48 7.5,7.33 9.31,0.88 16.94,5.77 22.38,12.75 3.24,4.16 5.71,9.09 7.29,14.33 1.56,5.22 2.24,10.77 1.95,16.23 -0.53,9.8 -4.2,19.35 -11.61,26.33 1.3,0.04 2.53,0.33 3.61,0.91 4.14,2.15 4.27,6.82 3.19,10.75 -1.08,3.28 -2.44,7.08 -3.73,10.28 -1.56,4.31 -3.85,5.12 -8.27,4.65 -9.93,43.45 -69.98,44.93 -82.53,0.04zm40.01 -135.69c87.64,0 158.63,71.04 158.63,158.63 0,87.64 -71.04,158.63 -158.63,158.63 -87.63,0 -158.63,-71.04 -158.63,-158.63 0,-87.64 71.04,-158.63 158.63,-158.63z"
              />
            </svg>
          </span>
          <span class="ml-2 text-blue-600 text-lg">Experience:</span>
        </div>
        <p class="ml-8 font-bold">
          <%= gettext("%{years} Years", years: @years) %> and <%= ngettext(
            "1 Month",
            "%{count} Months",
            @months
          ) %> Worked at OptimumBA, and now Freelancing and Open Source.
        </p>
      </li>
      <li>
        <div class="flex items-center mb-1">
          <span>
            <svg
              version="1.1"
              id="Layer_1"
              xmlns="http://www.w3.org/2000/svg"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              x="0px"
              y="0px"
              viewBox="0 0 122.88 110.37"
              style="enable-background:new 0 0 122.88 110.37"
              xml:space="preserve"
              class="w-6 h-6 fill-current text-blue-600 dark:text-white"
            >
              <style type="text/css">
                .st0{fill-rule:evenodd;clip-rule:evenodd;}
              </style>
              <g>
                <path
                  class="st0"
                  d="M61.92,0c10.42,0,18.86,8.44,18.86,18.86c0,10.42-8.44,18.86-18.86,18.86c-10.42,0-18.86-8.44-18.86-18.86 C43.07,8.44,51.51,0,61.92,0L61.92,0z M30.19,47.55c2.66-3.81,6.29-4.13,11.61-4.75h39.53c6.14,1.12,10.47,2.19,13.42,7.29 l23.21,31.74c2.65,3.62,4.93,5.88,4.92,10.7c-0.01,3.94-1.91,7.56-5.04,9.59c-4.02,2.62-7.09,1.85-11.15,0.43l-15.93-5.56v13.38 H31.64V97.78l-18.5,5.44c-6.04,1.31-10.35-0.93-12.1-5.14c-2.92-6.99,0.82-11.77,4.65-16.93L30.19,47.55L30.19,47.55z M32.19,76.02 V53.35l29.38,9.97l29.74-10.7V76.2c-20.53-4.3-21.39,14.31-8.7,20.31l-21.4,6.71l-20.67-7.25C53.58,89.97,50.92,70.71,32.19,76.02 L32.19,76.02z"
                />
              </g>
            </svg>
          </span>
          <span class="ml-2 text-blue-600 text-lg">Learning:</span>
        </div>
        <p class="ml-8 font-bold">Currently Learning Python and React Native</p>
      </li>
      <li>
        <div class="flex items-center mb-1">
          <span>
            <svg
              version="1.1"
              id="Layer_1"
              xmlns="http://www.w3.org/2000/svg"
              xmlns:xlink="http://www.w3.org/1999/xlink"
              x="0px"
              y="0px"
              viewBox="0 0 96.03 122.88"
              style="enable-background:new 0 0 96.03 122.88"
              xml:space="preserve"
              class="w-6 h-6 fill-current text-blue-600 dark:text-white"
            >
              <g>
                <path d="M50.39,0c3.59,0,6.84,1.46,9.19,3.81C61.94,6.16,63.4,9.41,63.4,13c0,3.59-1.46,6.84-3.82,9.19 C57.23,24.55,53.98,26,50.39,26c-3.59,0-6.84-1.46-9.19-3.81c-2.35-2.35-3.81-5.6-3.81-9.19c0-3.59,1.46-6.84,3.81-9.19 C43.55,1.46,46.8,0,50.39,0L50.39,0z M25.72,37.59l9.25-6.06c2.09-1.37,7.78-2.16,13.34-2.2c5.19-0.04,10.42,0.57,12.68,1.97 l9.33,6.11l1.4,0.93c0.33,0.22,0.59,0.43,0.81,0.62c0.28-0.28,0.65-0.61,1.13-0.99l1.55-1.21c0.79-0.61,1.57-1.25,2.36-1.92 c0.77-0.65,1.54-1.34,2.32-2.06c0.81-0.74,1.57-1.46,2.29-2.17c0.72-0.7,1.41-1.41,2.1-2.11l0.09-0.09 c1.31-1.33,3.04-2.02,4.78-2.04c1.7-0.02,3.42,0.59,4.75,1.84l0.1,0.09c1.33,1.31,2.02,3.04,2.04,4.78 c0.02,1.74-0.61,3.49-1.92,4.84c-0.81,0.84-1.64,1.67-2.47,2.49c-0.85,0.84-1.7,1.64-2.53,2.41c-0.87,0.8-1.77,1.6-2.7,2.39 c-0.91,0.77-1.87,1.55-2.89,2.34l-1.4,1.09c-0.02,0.02-0.15,0.13-0.17,0.13c-3.53,2.75-5.32,4.15-8.54,4.41l-0.05,0 c-1.79,0.13-3.2-0.14-4.68-0.79c-1.34-0.59-2.65-1.45-4.37-2.6l0.79,15.3l0.28,0.28c0.25,0.28,0.49,0.56,0.7,0.87 c0.88,1.26,1.77,2.54,2.64,3.84c0.9,1.34,1.82,2.74,2.74,4.21c0.89,1.41,1.76,2.85,2.59,4.32c0.83,1.46,1.63,2.97,2.4,4.54 c3.8,7.75,3.78,7.82,1.63,14.5c-0.08,0.26-0.17,0.52-0.25,0.77c-0.13,0.41-0.26,0.8-0.36,1.13c-0.02,0.02-4.88,15.98-5.33,17.5 c-0.6,1.97-1.94,3.52-3.63,4.42c-1.68,0.9-3.7,1.16-5.67,0.56l-0.02,0c-1.97-0.6-3.52-1.94-4.42-3.63 c-0.9-1.68-1.16-3.71-0.56-5.68l5.29-17.37l0.03-0.12l0.41-1.34l0.26-0.79c0.33-1.03,0.34-1.05-0.77-3.31l-0.04-0.07 c-0.61-1.24-1.28-2.48-1.99-3.73c-0.71-1.25-1.47-2.5-2.25-3.74c-0.42-0.66-0.9-1.39-1.41-2.17l-1.02-1.53l-0.11,0.01 c0.14,0.54,0.26,1.04,0.38,1.52c0.22,0.94,0.42,1.89,0.6,2.85c1.86,9.83,1.35,10.88-2.15,17.55c-0.04,0.09-0.08,0.17-0.13,0.25 l-0.61,1.18l-0.74,1.45l-7.71,15.38c-0.92,1.84-2.5,3.14-4.31,3.74c-1.8,0.6-3.83,0.52-5.67-0.39l-0.03-0.01 c-1.84-0.92-3.14-2.5-3.74-4.31c-0.6-1.8-0.52-3.84,0.39-5.67l7.72-15.41c0.58-1.16,1.05-2.06,1.46-2.84l0.07-0.14 c0.74-1.42,1.17-2.24,1.28-3.15c0.12-1-0.06-2.35-0.54-4.85c-0.15-0.79-0.32-1.58-0.5-2.36c-0.19-0.82-0.38-1.58-0.57-2.28 c-0.18-0.64-0.41-1.41-0.69-2.3l0.01,0c-0.23-0.73-0.51-1.55-0.84-2.48l-0.01-0.03c-0.08-0.24-0.15-0.47-0.2-0.69l-0.1-0.44 c-0.03-0.1-0.06-0.2-0.07-0.31l-3.06-27.98c-1.51,0.99-3.19,2-4.67,3.06c-1.79,1.19-3.13,2.08-4.51,2.68 c-1.48,0.65-2.89,0.92-4.68,0.79c-1.66-0.12-2.97-0.57-4.36-1.36c-1.24-0.71-2.53-1.71-4.22-3.04c-0.53-0.39-1.06-0.82-1.58-1.23 c-1.02-0.78-1.98-1.56-2.89-2.34c-0.93-0.79-1.83-1.59-2.7-2.39c-0.83-0.76-1.67-1.57-2.53-2.41c-0.83-0.82-1.66-1.65-2.47-2.49 c-1.31-1.35-1.95-3.1-1.92-4.84c0.02-1.71,0.68-3.41,1.97-4.71l0.08-0.08c1.35-1.31,3.1-1.95,4.84-1.92 c1.71,0.02,3.41,0.68,4.7,1.97l0.08,0.08c0.71,0.73,1.43,1.46,2.17,2.18c0.72,0.71,1.48,1.43,2.29,2.17 c0.78,0.72,1.56,1.41,2.32,2.06c0.78,0.67,1.57,1.31,2.36,1.92c0.51,0.4,1.03,0.83,1.55,1.21c0.48,0.38,0.85,0.71,1.14,0.99 c0.2-0.18,0.43-0.37,0.73-0.58C24.73,38.23,25.23,37.92,25.72,37.59L25.72,37.59z" />
              </g>
            </svg>
          </span>
          <span class="ml-2 text-blue-600 text-lg">Funtime:</span>
        </div>
        <p class="ml-8 font-bold">
          I enjoy morning runs, cycling, swimming, cooking, aprendiendo español, and spending quality time with my daughter as I wait for her to become of age and teach me new stuff 😎.
        </p>
      </li>
    </ul>
    """
  end

  @doc """
  Renders a modal for sharing blog to other social networks.

  ## Examples

      <.share_blog_modal id="confirm-modal">
        This is a modal.
      </.share_blog_modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.share_blog_modal id="share" on_cancel={JS.navigate(~p"/posts")}>
        This is another modal.
      </.share_blog_modal>

  """

  attr :id, :string, required: true
  attr :header, :string, default: nil
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def share_blog_modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <div
        class="absolute bottom-0 right-0 w-[15rem]"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
          <.focus_wrap
            id={"#{@id}-container"}
            phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
            phx-key="escape"
            phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
            class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-zinc-400 px-4 py-6 shadow-lg ring-1 transition"
          >
            <div class="absolute top-2 right-2 text-black">
              <button
                phx-click={JS.exec("data-cancel", to: "##{@id}")}
                type="button"
                class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                aria-label={gettext("close")}
              >
                <.icon name="hero-x-mark-solid" class="h-5 w-5" />
              </button>
            </div>
            <div
              id={"#{@id}-content"}
              class="flex items-center justify-center space-x-2 text-black dark:text-white"
            >
              <%= render_slot(@inner_block) %>
            </div>
          </.focus_wrap>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a modal.

  ## Examples

      <.modal id="confirm-modal">
        This is a modal.
      </.modal>

  JS commands may be passed to the `:on_cancel` to configure
  the closing/cancel event, for example:

      <.modal id="confirm" on_cancel={JS.navigate(~p"/posts")}>
        This is another modal.
      </.modal>

  """
  attr :id, :string, required: true
  attr :header, :string, default: nil
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden"
    >
      <div id={"#{@id}-bg"} class="bg-zinc-50/90 fixed inset-0 transition-opacity" aria-hidden="true" />
      <div
        class="fixed inset-0 overflow-y-auto"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="flex min-h-full items-center justify-center">
          <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
            <.focus_wrap
              id={"#{@id}-container"}
              phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
              phx-key="escape"
              phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
              class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-white p-14 shadow-lg ring-1 transition"
            >
              <div class="absolute top-6 right-5">
                <button
                  phx-click={JS.exec("data-cancel", to: "##{@id}")}
                  type="button"
                  class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                  aria-label={gettext("close")}
                >
                  <.icon name="hero-x-mark-solid" class="h-5 w-5" />
                </button>
              </div>
              <div id={"#{@id}-content"}>
                <%= render_slot(@inner_block) %>
              </div>
            </.focus_wrap>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :header, :string, default: nil
  attr :show, :boolean, default: false
  attr :on_cancel, JS, default: %JS{}
  slot :inner_block, required: true

  defp mobile_navigation_modal(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@show && show_modal(@id)}
      phx-remove={hide_modal(@id)}
      data-cancel={JS.exec(@on_cancel, "phx-remove")}
      class="relative z-50 hidden bg-black"
    >
      <div
        class="fixed inset-0 top-16 overflow-y-auto sm:hidden"
        aria-labelledby={"#{@id}-title"}
        aria-describedby={"#{@id}-description"}
        role="dialog"
        aria-modal="true"
        tabindex="0"
      >
        <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
          <.focus_wrap
            id={"#{@id}-container"}
            phx-window-keydown={JS.exec("data-cancel", to: "##{@id}")}
            phx-key="escape"
            phx-click-away={JS.exec("data-cancel", to: "##{@id}")}
            class="shadow-zinc-700/10 ring-zinc-700/10 relative hidden rounded-2xl bg-zinc-800 p-8 shadow-lg ring-1 transition"
          >
            <div class="absolute top-6 right-5">
              <button
                phx-click={JS.exec("data-cancel", to: "##{@id}")}
                type="button"
                class="-m-3 flex-none p-3 opacity-20 hover:opacity-40"
                aria-label={gettext("close")}
              >
                <.icon name="hero-x-mark-solid" class="h-5 w-5" />
              </button>
            </div>
            <div id={"#{@id}-content"}>
              <%= render_slot(@inner_block) %>
            </div>
          </.focus_wrap>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash kind={:info} phx-mounted={show("#flash")}>Welcome Back!</.flash>
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <div
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      role="alert"
      class={[
        "fixed top-2 right-2 mr-2 w-80 sm:w-96 z-50 rounded-lg p-3 ring-1",
        @kind == :info && "bg-emerald-50 text-emerald-800 ring-emerald-500 fill-cyan-900",
        @kind == :error && "bg-rose-50 text-rose-900 shadow-md ring-rose-500 fill-rose-900"
      ]}
      {@rest}
    >
      <p :if={@title} class="flex items-center gap-1.5 text-sm font-semibold leading-6">
        <.icon :if={@kind == :info} name="hero-information-circle-mini" class="h-4 w-4" />
        <.icon :if={@kind == :error} name="hero-exclamation-circle-mini" class="h-4 w-4" />
        <%= @title %>
      </p>
      <p class="mt-2 text-sm leading-5"><%= msg %></p>
      <button type="button" class="group absolute top-1 right-1 p-2" aria-label={gettext("close")}>
        <.icon name="hero-x-mark-solid" class="h-5 w-5 opacity-40 group-hover:opacity-70" />
      </button>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id}>
      <.flash kind={:info} title={gettext("Success!")} flash={@flash} />
      <.flash kind={:error} title={gettext("Error!")} flash={@flash} />
      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error")}
        phx-connected={hide("#client-error")}
        hidden
      >
        <%= gettext("Attempting to reconnect") %>
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error")}
        phx-connected={hide("#server-error")}
        hidden
      >
        <%= gettext("Hang in there while we get back on track") %>
        <.icon name="hero-arrow-path" class="ml-1 h-3 w-3 animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Renders a simple form.

  ## Examples

      <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:email]} label="Email"/>
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
  """
  attr :for, :any, required: true, doc: "the data structure for the form"
  attr :as, :any, default: nil, doc: "the server side parameter to collect all input under"

  attr :rest, :global,
    include: ~w(autocomplete name rel action enctype method novalidate target multipart),
    doc: "the arbitrary HTML attributes to apply to the form tag"

  slot :inner_block, required: true
  slot :actions, doc: "the slot for form actions, such as a submit button"

  def simple_form(assigns) do
    ~H"""
    <.form :let={f} for={@for} as={@as} {@rest}>
      <div class="mt-10 space-y-8 bg-white">
        <%= render_slot(@inner_block, f) %>
        <div :for={action <- @actions} class="mt-2 flex items-center justify-between gap-6">
          <%= render_slot(action, f) %>
        </div>
      </div>
    </.form>
    """
  end

  @doc """
  Renders a button.

  ## Examples

      <.button>Send!</.button>
      <.button phx-click="go" class="ml-2">Send!</.button>
  """
  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 py-2 px-3",
        "text-sm font-semibold leading-6 text-white active:text-white/80",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc """
  Renders an input with label and error messages.

  A `Phoenix.HTML.FormField` may be passed as argument,
  which is used to retrieve the input name, id, and values.
  Otherwise all attributes may be passed explicitly.

  ## Types

  This function accepts all HTML input types, considering that:

    * You may also set `type="select"` to render a `<select>` tag

    * `type="checkbox"` is used exclusively to render boolean values

    * For live file uploads, see `Phoenix.Component.live_file_input/1`

  See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input
  for more information. Unsupported types, such as hidden and radio,
  are best written directly in your templates.

  ## Examples

      <.input field={@form[:email]} type="email" />
      <.input name="my-input" errors={["oh no!"]} />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file month number password
               range search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "checkbox"} = assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Form.normalize_value("checkbox", assigns[:value])
      end)

    ~H"""
    <div>
      <label class="flex items-center gap-4 text-sm leading-6 text-zinc-600">
        <input type="hidden" name={@name} value="false" disabled={@rest[:disabled]} />
        <input
          type="checkbox"
          id={@id}
          name={@name}
          value="true"
          checked={@checked}
          class="rounded border-zinc-300 text-zinc-900 focus:ring-0"
          {@rest}
        />
        <%= @label %>
      </label>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "select"} = assigns) do
    ~H"""
    <div>
      <.label for={@id}><%= @label %></.label>
      <select
        id={@id}
        name={@name}
        class="mt-2 block w-full rounded-md border border-gray-300 bg-white shadow-sm focus:border-zinc-400 focus:ring-0 sm:text-sm"
        multiple={@multiple}
        {@rest}
      >
        <option :if={@prompt} value=""><%= @prompt %></option>
        <%= Phoenix.HTML.Form.options_for_select(@options, @value) %>
      </select>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  def input(%{type: "textarea"} = assigns) do
    ~H"""
    <div>
      <.label for={@id}><%= @label %></.label>
      <textarea
        id={@id}
        name={@name}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6 min-h-[6rem]",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def input(assigns) do
    ~H"""
    <div>
      <.label for={@id}><%= @label %></.label>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "mt-2 block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6",
          @errors == [] && "border-zinc-300 focus:border-zinc-400",
          @errors != [] && "border-rose-400 focus:border-rose-400"
        ]}
        {@rest}
      />
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  @doc """
  Renders a label.
  """
  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="block text-sm font-semibold leading-6 text-zinc-800">
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  @doc """
  Generates a generic error message.
  """
  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="mt-3 flex gap-3 text-sm leading-6 text-rose-600">
      <.icon name="hero-exclamation-circle-mini" class="mt-0.5 h-5 w-5 flex-none" />
      <%= render_slot(@inner_block) %>
    </p>
    """
  end

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil

  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", @class]}>
      <div>
        <h1 class="text-lg font-semibold leading-8 text-zinc-800">
          <%= render_slot(@inner_block) %>
        </h1>
        <p :if={@subtitle != []} class="mt-2 text-sm leading-6 text-zinc-600">
          <%= render_slot(@subtitle) %>
        </p>
      </div>
      <div class="flex-none"><%= render_slot(@actions) %></div>
    </header>
    """
  end

  @doc ~S"""
  Renders a table with generic styling.

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="overflow-y-auto px-4 sm:overflow-visible sm:px-0">
      <table class="w-[40rem] mt-11 sm:w-full">
        <thead class="text-sm text-left leading-6 text-zinc-500">
          <tr>
            <th :for={col <- @col} class="p-0 pb-4 pr-6 font-normal"><%= col[:label] %></th>
            <th :if={@action != []} class="relative p-0 pb-4">
              <span class="sr-only"><%= gettext("Actions") %></span>
            </th>
          </tr>
        </thead>
        <tbody
          id={@id}
          phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
          class="relative divide-y divide-zinc-100 border-t border-zinc-200 text-sm leading-6 text-zinc-700"
        >
          <tr :for={row <- @rows} id={@row_id && @row_id.(row)} class="group hover:bg-zinc-50">
            <td
              :for={{col, i} <- Enum.with_index(@col)}
              phx-click={@row_click && @row_click.(row)}
              class={["relative p-0", @row_click && "hover:cursor-pointer"]}
            >
              <div class="block py-4 pr-6">
                <span class="absolute -inset-y-px right-0 -left-4 group-hover:bg-zinc-50 sm:rounded-l-xl" />
                <span class={["relative", i == 0 && "font-semibold text-zinc-900"]}>
                  <%= render_slot(col, @row_item.(row)) %>
                </span>
              </div>
            </td>
            <td :if={@action != []} class="relative w-14 p-0">
              <div class="relative whitespace-nowrap py-4 text-right text-sm font-medium">
                <span class="absolute -inset-y-px -right-4 left-0 group-hover:bg-zinc-50 sm:rounded-r-xl" />
                <span
                  :for={action <- @action}
                  class="relative ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
                >
                  <%= render_slot(action, @row_item.(row)) %>
                </span>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end

  @doc """
  Renders a data list.

  ## Examples

      <.list>
        <:item title="Title"><%= @post.title %></:item>
        <:item title="Views"><%= @post.views %></:item>
      </.list>
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-zinc-100">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
          <dt class="w-1/4 flex-none text-zinc-500"><%= item.title %></dt>
          <dd class="text-zinc-700"><%= render_slot(item) %></dd>
        </div>
      </dl>
    </div>
    """
  end

  @doc """
  Renders a back navigation link.

  ## Examples

      <.back navigate={~p"/posts"}>Back to posts</.back>
  """
  attr :navigate, :any, required: true
  slot :inner_block, required: true

  def back(assigns) do
    ~H"""
    <div class="mt-16">
      <.link
        navigate={@navigate}
        class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
      >
        <.icon name="hero-arrow-left-solid" class="h-3 w-3" />
        <%= render_slot(@inner_block) %>
      </.link>
    </div>
    """
  end

  @doc """
  Renders a [Heroicon](https://heroicons.com).

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from the `deps/heroicons` directory and bundled within
  your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 animate-spin" />
  """
  attr :name, :string, required: true
  attr :class, :string, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      time: 300,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  def show_modal(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.show(to: "##{id}")
    |> JS.show(
      to: "##{id}-bg",
      time: 300,
      transition: {"transition-all transform ease-out duration-300", "opacity-0", "opacity-100"}
    )
    |> show("##{id}-container")
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}-content")
  end

  def hide_modal(js \\ %JS{}, id) do
    js
    |> JS.hide(
      to: "##{id}-bg",
      transition: {"transition-all transform ease-in duration-200", "opacity-100", "opacity-0"}
    )
    |> hide("##{id}-container")
    |> JS.hide(to: "##{id}", transition: {"block", "block", "hidden"})
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(JrowahWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(JrowahWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end

  defp main_nav_links do
    [
      %{label: "Home", unique_class: "desktop-home-link", route: ~p"/"},
      %{
        label: "Blog",
        unique_class: "desktop-blog-link",
        route: ~p"/blog"
      },
      %{
        label: "Projects",
        unique_class: "desktop-projects-link",
        route: ~p"/projects"
      },
      %{
        label: "Journey",
        unique_class: "desktop-journey-link",
        route: ~p"/journey"
      }
    ]
  end

  defp active?(current_url, route) do
    %{path: path} = URI.parse(current_url)

    if route == "/", do: path == route, else: String.starts_with?(path, route)
  end

  defp social_links do
    [
      %{
        label: "Twitter",
        svg:
          "<svg viewBox=\"0 0 24 24\" aria-hidden=\"true\" class='w-6 h-6 text-content fill-current'>
      <path d=\"M13.3174 10.7749L19.1457 4H17.7646L12.7039 9.88256L8.66193 4H4L10.1122 12.8955L4 20H5.38119L10.7254 13.7878L14.994 20H19.656L13.3171 10.7749H13.3174ZM11.4257 12.9738L10.8064 12.0881L5.87886 5.03974H8.00029L11.9769 10.728L12.5962 11.6137L17.7652 19.0075H15.6438L11.4257 12.9742V12.9738Z\">
      </path>
    </svg>",
        link: "https://twitter.com/jrowah"
      },
      %{
        label: "GitHub",
        svg:
          "<svg viewBox=\"0 0 24 24\" aria-hidden=\"true\" class='w-6 h-6 text-content fill-current'>
      <path
        fill-rule=\"evenodd\"
        clip-rule=\"evenodd\"
        d=\"M12 2C6.475 2 2 6.588 2 12.253c0 4.537 2.862 8.369 6.838 9.727.5.09.687-.218.687-.487 0-.243-.013-1.05-.013-1.91C7 20.059 6.35 18.957 6.15 18.38c-.113-.295-.6-1.205-1.025-1.448-.35-.192-.85-.667-.013-.68.788-.012 1.35.744 1.538 1.051.9 1.551 2.338 1.116 2.912.846.088-.666.35-1.115.638-1.371-2.225-.256-4.55-1.14-4.55-5.062 0-1.115.387-2.038 1.025-2.756-.1-.256-.45-1.307.1-2.717 0 0 .837-.269 2.75 1.051.8-.23 1.65-.346 2.5-.346.85 0 1.7.115 2.5.346 1.912-1.333 2.75-1.05 2.75-1.05.55 1.409.2 2.46.1 2.716.637.718 1.025 1.628 1.025 2.756 0 3.934-2.337 4.806-4.562 5.062.362.32.675.936.675 1.897 0 1.371-.013 2.473-.013 2.82 0 .268.188.589.688.486a10.039 10.039 0 0 0 4.932-3.74A10.447 10.447 0 0 0 22 12.253C22 6.588 17.525 2 12 2Z\"
      >
      </path>
    </svg>",
        link: "https://github.com/jrowah"
      },
      %{
        label: "LinkedIn",
        svg:
          "<svg viewBox='0 0 24 24' aria-hidden='true' class='w-6 h-6 text-content fill-current'>
      <path d='M18.335 18.339H15.67v-4.177c0-.996-.02-2.278-1.39-2.278-1.389 0-1.601 1.084-1.601 2.205v4.25h-2.666V9.75h2.56v1.17h.035c.358-.674 1.228-1.387 2.528-1.387 2.7 0 3.2 1.778 3.2 4.091v4.715zM7.003 8.575a1.546 1.546 0 01-1.548-1.549 1.548 1.548 0 111.547 1.549zm1.336 9.764H5.666V9.75H8.34v8.589zM19.67 3H4.329C3.593 3 3 3.58 3 4.297v15.406C3 20.42 3.594 21 4.328 21h15.338C20.4 21 21 20.42 21 19.703V4.297C21 3.58 20.4 3 19.666 3h.003z'>
      </path>
    </svg>",
        link: "https://www.linkedin.com/in/james-rowa/"
      }
    ]
  end
end
