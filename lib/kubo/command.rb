# frozen_string_literal: true

require "tty-option"

module Kubo
  class Command
    include TTY::Option

    usage do
      program "kubo"

      command "pods"

      desc "Interact with pods for a given namespace"
    end

    keyword :ns do
      required
      arity one_or_more
      desc "The name of the namespace to use"
    end

    flag :help do
      short "-h"
      long "--help"
      desc "Print usage"
    end

    def run
      if params[:help]
        print help
        exit
      else
        pp params.to_h
      end
    end
  end
end
