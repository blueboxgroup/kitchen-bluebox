# -*- encoding: utf-8 -*-
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright (C) 2012, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'benchmark'
require 'fog'

require 'kitchen'

module Kitchen

  module Driver

    # Blue Box blocks API driver for Test Kitchen.
    #
    # @author Fletcher Nichol <fnichol@nichol.ca>
    class Bluebox < Kitchen::Driver::SSHBase

      default_config :flavor_id,    '94fd37a7-2606-47f7-84d5-9000deda52ae'
      default_config :image_id,     '573b8e80-823f-4100-bc2c-51b7c60f633c'
      default_config :location_id,  '37c2bd9a-3e81-46c9-b6e2-db44a25cc675'
      default_config :username,     'kitchen'

      required_config :bluebox_customer_id
      required_config :bluebox_api_key

      def create(state)
        server = create_server
        state[:block_id] = server.id
        state[:hostname] = server.ips.first['address']

        info("Blocks instance <#{state[:block_id]}> created.")
        server.wait_for { print "."; ready? } ; print "(server ready)"
        wait_for_sshd(state[:hostname])       ; print "(ssh ready)\n"
      rescue Fog::Errors::Error, Excon::Errors::Error => ex
        raise ActionFailed, ex.message
      end

      def destroy(state)
        return if state[:block_id].nil?

        connection.destroy_block(state[:block_id])
        update_state_for_destroy(state)
      rescue Fog::Compute::Bluebox::NotFound
        update_state_for_destroy(state)
      rescue Fog::Errors::Error, Excon::Errors::Error => ex
        raise ActionFailed, ex.message
      end

      private

      def connection
        Fog::Compute.new(
          :provider             => :bluebox,
          :bluebox_customer_id  => config[:bluebox_customer_id],
          :bluebox_api_key      => config[:bluebox_api_key],
        )
      end

      def create_server
        opts = {
          :flavor_id    => config[:flavor_id],
          :image_id     => config[:image_id],
          :location_id  => config[:location_id],
          :hostname     => instance.name,
          :username     => config[:username],
        }
        if config[:password]
          opts[:password] = config[:password]
        end
        if config[:ssh_public_key] && File.exists?(config[:ssh_public_key])
          opts[:public_key] = IO.read(config[:ssh_public_key])
        end

        connection.servers.create(opts)
      end

      def update_state_for_destroy(state)
        info("Blocks instance <#{state[:block_id]}> destroyed.")
        state.delete(:block_id)
        state.delete(:hostname)
      end

    end
  end
end
