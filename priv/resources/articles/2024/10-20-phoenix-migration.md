%{
slug: "phoenix-migration",
title: "Migrating Website from Gatsby to Phoenix and LiveView",
description: "How and why I migrated from using React's Gatsby Framework and Netlify to using Phoenix, LiveView and Fly.io for my personal portfolio.",
next_article_slug: nil,
previous_article_slug: nil,
published: true,
tags: ["website", "portfolio", "blogging"],
hero_image: "/images/2024/elixir_phoenix.avif"
}

---

## Introduction

Hello world. So I got hooked into Elixir, Phoenix and LiveView and finally got convinced I needed to rebuild my website with these tools. In this blog post, I write about why and how I migrated my personal website from using GatsbyJS, [here](https://github.com/jrowah/jrowah.dev/tree/website_2.0) is a Git branch with the old one, to using Elixir and Phoenix. If you are wondering whether using Elixir and Phoenix for a simple site is an overkill, I do not think so, but trust me it's worth it. This tech stack is awesome from pretty much anything, from a simple site such as this one to very huge apps like like Spotify, Pinterest, Discord, and Whatsapp, some of which are powered by Erlang, a language on top of which Elixir is built. 

Let's get started.

## Life before Elixir and Phoenix

Before I discovered the world of Elixir, I had just learned the MERN stack and was playing around with some hobby applications, the most significant one being a product expiry tracker application (check it out in the projects page). I hosted free on heroku but when they ended their free hosting plan, it now only lives on github.
Back to my website, when I initially built it, I exclusively followed [<span style="color: blue; text-decoration: underline;,">the GatsbyJS documentation</span>](https://www.gatsbyjs.com/docs/tutorial/getting-started/). I was primarily working with JavaScript and was trying out different frameworks and libraries. After moving to functional programming, I said why not go all the way, which I did and the result is fantastic.

## How I did it
It's pretty simple getting started with a new phoenix application using the mix command. One of the best things about Elixir and Phoenix is documentation. From installation to getting started, it is made so simple for new comers, whether you are a veteran who wants to try out Elixir or just getting started in the industry. These links can help you get started with installing the software, but if you are on Linux or MacOS, you can also get all under one roof from a setup in an open source project I contributed to developing which is owned by the company I previously worked for. Here is the [setup command](https://phx.tools/).

So of course I had all the setup done when I decided to switch my website, and so just as the phoenix documentation states, I just ran the command that creates a new app, although I tweaked it a little bit since I wanted to generate the files within the root folder where I already had my website and I did not want ecto as well. So I executed;

```elixir
 mix phx.new . --no-ecto
```

This generated the basic building block of this website. The --no-ecto flag prevents the generation of Ecto, Phoenix's PostgresQL DB wrapper from being generated along with the other files. Note that you have to pass the name of your app as in the documentation if you do not already have a folder that is tracked by Git. When you run the command after getting some knowledge on Phoenix, you realize how the generated code easy to customize, which is one of the reasons I love Phoenix.
All I did was customize what was generated and built this website. Another awesome thing is that the app comes with TailwindCSS already configured and if you have knowledge of that you are good to go.

## Going Forward?

This website is a playground as I continue to get deep into Elixir and Phoenix. I realized the best way to learn is by doing and so this is one of the places where I will often get my hands dirty while trying out new things especially with Phoenix and LiveView. I should mention that this project relies mostly on what the Phoenix framework offers and barely scratches the surface with regards to the more exotic features that Beam/OTP offers. However, I will continue to try out more stuff I that I can add to its functionality, which means I will be posting related blogs periodically. For now I think it is work mentioning to you a little bit more of the greatness in Elixir and OPT by highlighting some of their benefits. If you are already familiar with Elixir and Erlang, you can pass this section.

## Why I think Elixir and Phoenix is one of the Best Combinations out here.

If it is you are just hearing about Elixir, I recommend you watch [this documentary](https://www.youtube.com/watch?v=lxYFOM3UJzo) which features the creator, Jose Valim. He talks about why he create Elixir, and this offers a very strong foundation.

Elixir and Phoenix have a lot to offer and some of the benefits are:

### Real time Features with Minimal Effort

With Phoenix LiveView, adding real-time interactivity, such as dynamic updates or live feedback, doesn’t require writing JavaScript-heavy front-end code. You get real-time features by default, which is great for a modern, interactive website.

For example, if you wish to show real-time page visit counts on a blog post, which is a feature I intend to add sometime soon and will write a blog about, you don’t need to juggle multiple languages or frameworks. LiveView handles it all with ease using WebSockets, without the complexity of a separate front-end framework.

### Seamless Server-Side Rendering
Unlike the JavaScript-heavy GatsbyJS, Phoenix offers server-side rendering out of the box. This means your pages are fast, your SEO is stronger, and users see content right away, which is critical for a static site like a personal portfolio or blog.

### Developer Productivity
Elixir’s syntax is concise and its functional programming paradigm makes it easier to reason about code. Phoenix’s convention over configuration approach also saves time, allowing me to focus more on building features rather than configuring things from scratch.

Also, the performance of Elixir’s OTP (Erlang's runtime) allows you to handle more traffic and parallel tasks without scaling too early. So, even if your static site grows into something more complex, Phoenix can handle it.

### Unified Codebase
By using Phoenix LiveView, you avoid the complexities of managing separate front-end and back-end codebases. Everything is written in Elixir, and there’s no need for separate APIs or different deployments. For someone who enjoys working with Elixir, this reduces cognitive overhead and ensures faster development cycles.

### Built-in Asset Management
Phoenix has integrated asset management, which makes it easier to handle static files like CSS, JavaScript, and images. You can customize or use TailwindCSS, as I did for this rebuild, without the need for extra tools like Webpack or a complex pipeline.

### Extensibility
Phoenix is not limited to simple static sites. With its scalability and support for channels, you can evolve your static site into a full-fledged application over time, adding real-time features or even e-commerce components if necessary. It’s flexible enough to handle a wide range of use cases.

### Performance
Elixir is built on top of BEAM, the Erlang VM, and so Elixir and Phoenix handles concurrent connections very well and uses RAM effectively.

### Easy Deployment

Deploying a phoenix application is very simple and you have a variety of options. You can choose which one suits you the most. Here is a post that talks about the options. Personally I use fly.io because it is cheap and is what the phoenix teams goes with currently.

And finally, may be in a different blog post that will talk about more back-end related development, I will dig deep into the specific benefits of Elixir on the backend where I will probably talk about stuff like Concurrency, Supervisor and Fault Tolerance, Erland Term Storage and its benefits in cashing, and a lot more. Be on the look out.

## Conclusion
In this blog post I wrote about why I switched to coding my website in Phoenix and LiveView, and linked some resources to help you get started with the PETL stack if you are interested. I also highlighted some of the benefits of using Elixir, Phoenix and LiveView in software development. If you found this article interesting, please share it. If you are interested in learning Elixir and Phoenix and need a one on one guidance, reach out so we can have fun together. Cheers!

## Sources
1. [Repository fo this Website](https://github.com/jrowah/jrowah.dev)
2. [Phoenix Documentation](https://www.phoenixframework.org/)
3. [Elixir and OTP](https://elixir-lang.org/docs.html)
4. [Deploying a Phoenix App to Fly.io](https://fly.io/docs/elixir/getting-started/)
5. [An interesting conversation on why elixir and phoenix are good for anything and everything]((https://elixirforum.com/t/is-elixir-and-phoenix-good-for-general-crud-applications-or-is-it-overkill/58209/4))
