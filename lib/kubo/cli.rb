# frozen_string_literal: true

require "tty-prompt"
require "kubeclient"

require_relative "command"
require_relative "../resources/pod"

module Kubo
  class Cli
    def initialize
      @command = Command.new
      @prompt = TTY::Prompt.new
      @context = config.context
    end

    def run
      @command.parse
      @command.run
      # namespaces = client.get_namespaces.map { |ns| ns.metadata.name }
      pods = client.get_pods(namespace: @command.params[:namespace].first).to_h { |pod| [pod.metadata.name, pod] }

      # pods = client.get_pods(label_selector: @command.params[:label]).map { |pod| pod.metadata.name }
      if pods.empty?
        puts "There are no matching pods"
      else
        pod_choice = @prompt.select("Which pods are you interested in?", pods, filter: true, per_page: 10)
        action = @prompt.expand("Which action would you like to take?") do |q|
          q.choice key: "d", name: "Delete", value: :delete
          q.choice key: "b", name: "Describe", value: :describe
          q.choice key: "l", name: "Logs", value: :logs
          q.choice key: "c", name: "Containers", value: :containers
          q.choice key: "q", name: "Quit", value: :quit
        end
        execute(action, Resources::Pod.new(pod_choice))
      end
    end

    private

    def execute(action, pod)
      case action
      when :delete
        puts "Deleting pod #{pod}"
      when :describe
        puts "Describing pod #{pod}"
      when :logs
        puts "Showing logs from pod #{pod.name}"
        container = @prompt.select("Select the container to display logs", pod.containers.map(&:name))
        puts client.get_pod_log(pod.name, pod.namespace, container: container)
      when :containers
        puts "Listing containers for pod #{pod}"
      when :quit
        puts "Do nothing"
      end
    end

    def client
      @client ||= Kubeclient::Client.new(
        @context.api_endpoint,
        "v1",
        ssl_options: @context.ssl_options,
        auth_options: @context.auth_options
      )
    end

    def config
      @config ||= Kubeclient::Config.read(ENV["KUBECONFIG"] || "/Users/lvieira/.kube/config")
    end
  end
end
