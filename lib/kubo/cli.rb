# frozen_string_literal: true

require "tty-prompt"
require "kubeclient"

module Kubo
  class Cli
    def initialize(argv)
      @argv = argv
      @prompt = TTY::Prompt.new
      @config = Kubeclient::Config.read(ENV["KUBECONFIG"] || "/Users/lvieira/.kube/config")
      @context = config.context(context_name)
    end

    def run
      namespaces = client.get_namespaces
      prompt.select("Which namespace are you interested in?", namespaces, filter: true)
    end

    private

    def client
      @client ||= Kubeclient::Client.new(
        @context.api_endpoint,
        "v1",
        ssl_options: @context.ssl_options,
        auth_options: @context.auth_options
      )
    end
  end
end
