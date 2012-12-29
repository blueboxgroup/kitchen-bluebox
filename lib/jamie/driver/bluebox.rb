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

require 'jamie'

module Jamie

  module Driver

    # Blue Box blocks API driver for Jamie.
    #
    # @author Fletcher Nichol <fnichol@nichol.ca>
    class Bluebox < Jamie::Driver::SSHBase

      default_config 'flavor_id',   '94fd37a7-2606-47f7-84d5-9000deda52ae'
      default_config 'image_id',    '573b8e80-823f-4100-bc2c-51b7c60f633c'
      default_config 'location_id', '37c2bd9a-3e81-46c9-b6e2-db44a25cc675'
      default_config 'username',    'jamie'
      default_config 'port',        '22'

      def create(instance, state)
        server = create_server(instance)
        state['block_id'] = server.id
        state['hostname'] = server.ips.first['address']

        elapsed = Benchmark.measure do
          server.wait_for { print "."; ready? } ; print "(server ready)"
          wait_for_sshd(state['hostname'])      ; print "(ssh ready)\n"
        end
        puts "       Created #{instance.name} in #{elapsed.real} seconds."
      rescue Fog::Errors::Error, Excon::Errors::Error => ex
        raise ActionFailed, ex.message
      end

      def destroy(instance, state)
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
