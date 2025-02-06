# 🚀 Archived Repository Notice

**Status:** Archived  
**Date:** 2025-02-06

This repository has been archived due to the discontinuation of [Line Notify](https://notify-bot.line.me/closing-announce). No further updates, bug fixes, or feature requests will be accepted. Please use this repository for historical reference only.

---

# LineReminder
[![Run Tests](https://github.com/denielchiang/line_reminder/actions/workflows/elixir.yaml/badge.svg)](https://github.com/denielchiang/line_reminder/actions/workflows/elixir.yaml) [![Fly Deploy](https://github.com/denielchiang/line_reminder/actions/workflows/fly.yaml/badge.svg)](https://github.com/denielchiang/line_reminder/actions/workflows/fly.yaml)

A calendar website that is able to send a Line message when the scheduled job is triggered.

## Prereq

  - Erlang 26.2.2
  - Elixir 1.16,1
  - Phoenix 1.7.12
  - Phoenix LiveView 0.18.16
  - PostgreSQL 15.3/16.1
  - [Generate](https://notify-bot.line.me/my/) your own Line access token

## Getting Started

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Seeds

Generate default message content, in this case the daliy bible reading chapter and paragraph

### Development
Seeding by `mix`
```Shell
$ mix run ./priv/repo/seeds.exs
```
### Server
Seeding on runtime
```Elixir
iex> LineReminder.Release.seeds(2024)
```

### Mix Tasks
- Original phoenix [mix tasks](https://hexdocs.pm/phoenix/1.7.2/mix_tasks.html)
- Credo [mix tasks](https://hexdocs.pm/credo/mix_tasks.html)
- Sobelow [mix tasks](https://hexdocs.pm/sobelow/Mix.Tasks.Sobelow.html#module-command-line-options)
- Dialyxir [mix tasks](https://hexdocs.pm/dialyxir/readme.html#usage)

### Dependencies
Dependencies that using

#### Dev & Test environment
- [credo](https://github.com/rrrene/credo)
- [sobelow](https://github.com/nccgroup/sobelow)
- [dialyxir](https://github.com/jeremyjh/dialyxir)

#### All environments
- [tzdata](https://github.com/lau/tzdata)
- [quantum-core](https://github.com/quantum-elixir/quantum-core)
- [heroicons_elixir](https://github.com/mveytsman/heroicons_elixir)
- [req](https://github.com/wojtekmach/req)
- [highlander](https://hexdocs.pm/highlander/Highlander.html#content)
- [libcluster](https://github.com/bitwalker/libcluster)
- [ok](https://hexdocs.pm/ok/readme.html)
 
### Deployment
It's using [fly.io](https://fly.io) for my own convenience to save my infrastructure time & personal study. Feel free to change whatever you like if you wanna create your own scheduling Line Notifier, it has nothing to do with the deploymnet section.

There're 2 ways to do the deployment.

#### Elixir CI/CD via GitHub Actions
Which is the part of `.github/workflows`, you can find further information either [GitHub](https://github.com/features/actions) or [Fly.io](https://fly.io/docs/elixir/advanced-guides/github-actions-elixir-ci-cd/). 
This action will be triggered by
- PR - Run Tests that includes Compile, Check Formatting, Run Dialyzer, Check Code Consistency(Credo), Check Security(Sobelow), Test Cases.
- Merge to main - Run Tests then deploy to Fly.io

#### Manually deploy
Require to install `flyctl`
```Shell
brew install flyctl
```
Deploy from building server on Fly.io
```Shell
fly deploy --remote-only
```

### Common use Fly commands
Check apps status
```Shell
fly apps list
```
Connect to Postgres that on Fly.io
```Shell
 fly postgres connect -a <DB_NAME>
 ```
 List secrets, environment variables, on Fly.io. Such as `LINE_TOKEN` in this case.
 ```Shell
 fly secrets list
 ```
 Remove secret - `LINE_TOKEN` for example
 ```Shell
 fly secrets unset LINE_TOKEY
 ```
 Set secret - `LINE_TOKEN`
 ```Shell
 fly secrets set LINE_TOKEN=<YOUR_LINE_TOKEN>
 ```
 SSH to server
 ```Shell
 fly ssh console
 ```
 Project log monitoring
 ```Shell
 fly logs
 ```
 
 ### Scheduling tasks
 Scheduling job is using [quantum 3.5](https://hexdocs.pm/quantum/readme.html).
 
 #### Config
 It will be triggered on every 6am, Timezone GMT+8.
 Feel free to change your `config/runtime.exs` whenever you like.
 ```Elixir
   config :line_reminder, LineReminder.Scheduler,
    timezone: "Asia/Taipei",
    overlap: false,
    run_strategy: Quantum.RunStrategy.Local,
    jobs: [
      {"0 6 * * *", {LineReminder.Messanger, :send, []}}
    ]
```
