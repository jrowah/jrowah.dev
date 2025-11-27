%{
slug: "deploying-phoenix-app-to-fly",
title: "Fixing Phoenix Socket Origin Error When Deploying to Fly.io with Custom Domain",
description: "A step-by-step guide to resolve the 'Could not check origin for Phoenix.Socket transport' error when deploying a Phoenix application to Fly.io with a custom domain.",
published: true,
tags: ["hosting", "deployment", "fly", "devops"],
hero_image: "/images/2024/fly_deploy.png"
}

---

## Introduction

While deploying my first client project to Fly.io with a custom `.co.ke` domain, I encountered a Phoenix Socket origin error. This guide explains how to resolve this common issue that occurs when setting up custom domains with Phoenix applications on Fly.io.

## The Problem

After successfully deploying a Phoenix application to Fly.io, adding a custom domain typically involves adding DNS records and then adding certificate for your custom domain by running:

```bash
fly certs add "*.example.com"
```

However, this can lead to the following error in your live logs:

```
[error] Could not check origin for Phoenix.Socket transport.
Origin of the request: https://www.example.com

This happens when you are attempting a socket connection to a different host than 
the one configured in your config/files.
```

## Understanding the Issue

This error occurs because Phoenix's socket connection is rejecting requests from your custom domain. By default, Phoenix strictly checks the origin of WebSocket connections as a security measure. When adding a custom domain, we need to explicitly allow connections from these new origins.

## The Solution

Here's a step-by-step guide to resolve this issue:

1. **Update Socket Origins Configuration**

Add the following to your `config/runtime.exs`:

```elixir
config :your_app, YourAppWeb.Endpoint,
  check_origin: [
    "https://yourdomain.co.ke",
    "https://www.yourdomain.co.ke"
  ]
```

2. **Configure SSL in Production**

In `config/prod.exs`, ensure proper SSL configuration:

```elixir
config :your_app, YourAppWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  force_ssl: [rewrite_on: [:x_forwarded_proto]]
```

3. **Verify Domain Configuration**

Ensure both A and AAAA DNS records are set up for:
- Root domain (`yourdomain.co.ke`)
- WWW subdomain (`www.yourdomain.co.ke`)

4. **Verify SSL Certificates**

Check the status of your certificates:

```bash
# View all certificates
fly certs show

# Check specific domains
fly certs check yourdomain.co.ke
fly certs check www.yourdomain.co.ke
```

## Important Notes

- Allow a few minutes for DNS changes and SSL certificates to propagate
- Both the root domain and www subdomain need proper configuration
- The `check_origin` list must include all domains you want to allow socket connections from

## References

For more detailed information, see [Chris McCord's explanation](https://community.fly.io/t/phoenix-liveview-constantly-refreshes-with-custom-domain/3384/3) on the Fly.io community forums.
