# Erlang Schedulers on Kubernetes

This is an example app used to illustrate how online schedulers are configured post OTP23 running in kubernetes. It expects at least 4 CPUs. If you don't have 4 CPUs available, change the `resources.limits.cpu` in `./k8s/pod.yaml`.

The application calculates primes, starting a task for each scheduler.

_This example is configured for running on docker for desktop using the local registry._

## Setup

1. Install docker-for-desktop 🙃
2. Run `make all`

## Running example

You'll need two terminals

1. Run `make top` in your first terminal. This will show you the current CPU usage of the container.
2. In a second terminal run `make shell`. This will open up a bash shell in the container.
3. Run `iex -S mix` in the container.
4. Run `K8sScheduler.run()`. If it returns too quickly, try: `K8sScheduler.run(1_000_000)`
5. Run Step #4 a number of times to saturate the available CPUs.

What you should see is the number of online schedulers is set to the `resources.limits.cpu`. As the CPUs are saturated, you should see mCPU amount rising in the first terminal.