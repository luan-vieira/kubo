# frozen_string_literal: true

require_relative "kubo/version"

module Kubo
  class Error < StandardError; end

  # Your code goes here...
  class Cli
    def initialize(argv)
      @argv = argv
    end

    def run
      puts "Hello World!"
    end
  end
end

__END__

#!/usr/bin/env ruby

require "tty-prompt"
require 'kubeclient'

prompt = TTY::Prompt.new
config = Kubeclient::Config.read(ENV['KUBECONFIG'] || '/Users/lvieira/.kube/config')

context_name = prompt.select("Which context would you like to use?", config.contexts)
context = config.context(context_name)

client = Kubeclient::Client.new(
  context.api_endpoint,
  'v1',
  ssl_options: context.ssl_options,
  auth_options: context.auth_options
)

namespaces = client.get_namespaces

prompt.select("Which namespace are you interested in?", warriors, filter: true)


