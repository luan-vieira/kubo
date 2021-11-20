# frozen_string_literal: true

module Resources
  class Container
    class << self
      def from_pod_resource(pod_resource)
        pod_resource.spec.containers.each do |spec|
          container_data = spec.to_h.merge(container_status(spec.name, pod_resource.status.containerStatuses).to_h)
          new(container_data)
        end
      end

      private

      def container_status(name, statuses)
        statuses.find { |status| status.name == name }
      end
    end

    def initialize(container_resource)
      @name = container_resource[:name]
      @image = container_resource[:image]
      @command = container_resource[:command]
      @env = container_resource[:env]
      @cpu = container_resource.dig(:resources, :requests, :cpu)
      @memory = container_resource.dig(:resources, :requests, :memory)
      @volume_mounts = container_resource[:volumeMounts]
      @image_pull_policy = container_resource[:imagePullPolicy]
      @ready = container_resource[:ready]
      @started = container_resource[:started]
      @state = container_resource[:state].keys.first
      @started_at = container_resource.dig(:state, :running, :startedAt)
      @last_state = container_resource[:last_state]
    end
  end
end
