# frozen_string_literal: true

require "tty-prompt"
require "kubeclient"

require_relative "command"

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
      namespaces = client.get_namespaces.map { |ns| ns.metadata.name }
      @prompt.select("Which namespace are you interested in?", namespaces, filter: true)
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

    def config
      @config ||= Kubeclient::Config.read(ENV["KUBECONFIG"] || "/Users/lvieira/.kube/config")
    end
  end
end
