# -*- encoding: utf-8 -*-

require 'benchmark'
require 'fog'

require 'jamie'

module Jamie

  module Driver

    # Blue Box blocks API driver for Jamie.
    class Bluebox < Jamie::Driver::SSHBase

      default_config 'flavor_id',   '94fd37a7-2606-47f7-84d5-9000deda52ae'
      default_config 'image_id',    '573b8e80-823f-4100-bc2c-51b7c60f633c'
      default_config 'location_id', '37c2bd9a-3e81-46c9-b6e2-db44a25cc675'
      default_config 'username',    'jamie'
      default_config 'port',        '22'

      def perform_create(instance, state)
        server = create_server(instance)
        state['block_id'] = server.id
        state['hostname'] = server.ips.first['address']

        elapsed = Benchmark.measure do
          server.wait_for { print "."; ready? } ; print "(server ready)"
          wait_for_sshd(state['hostname'])      ; print "(ssh read)\n"
        end
        puts "       Created #{instance.name} in #{elapsed.real} seconds."
      rescue Fog::Errors::Error, Excon::Errors::Error => ex
        raise ActionFailed, ex.message
      end

      def perform_destroy(instance, state)
        return if state['block_id'].nil?

        connection.destroy_block(state['block_id'])
        state.delete('block_id')
        state.delete('hostname')
      rescue Fog::Errors::Error, Excon::Errors::Error => ex
        raise ActionFailed, ex.message
      end

      private

      def connection
        Fog::Compute.new(
          :provider             => :bluebox,
          :bluebox_customer_id  => config['bluebox_customer_id'],
          :bluebox_api_key      => config['bluebox_api_key'],
        )
      end

      def create_server(instance)
        connection.servers.create(
          :flavor_id    => config['flavor_id'],
          :image_id     => config['image_id'],
          :location_id  => config['location_id'],
          :hostname     => instance.name,
          :username     => config['username'],
          :password     => config['password'],
        )
      end
    end
  end
end
