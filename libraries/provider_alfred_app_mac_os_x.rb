# Encoding: UTF-8
#
# Cookbook Name:: alfred
# Library:: provider_alfred_app_mac_os_x
#
# Copyright 2015-2016, Jonathan Hartman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'etc'
require 'chef/dsl/include_recipe'
require 'chef/provider/lwrp_base'
require_relative 'provider_alfred_app'
require_relative 'provider_alfred_app_mac_os_x_app_store'
require_relative 'provider_alfred_app_mac_os_x_direct'

class Chef
  class Provider
    class AlfredApp < Provider::LWRPBase
      # An empty parent class for the Alfred for OS X providers.
      #
      # @author Jonathan Hartman <j@p4nt5.com>
      class MacOsX < AlfredApp
        include Chef::DSL::IncludeRecipe

        # `URL` varies by sub-provider
        PATH ||= '/Applications/Alfred.app'.freeze

        private

        #
        # (see AlfredApp#enable!)
        #
        def enable!
          # TODO: This should eventually take the form of applescript and
          # login_item resources in the mac_os_x cookbook.
          cmd = "osascript -e 'tell application \"System Events\" to make " \
                'new login item at end with properties ' \
                "{name: \"Alfred\", path: \"#{PATH}\", hidden: false}'"
          enabled_status = enabled?
          execute 'enable alfred' do
            command cmd
            action :run
            only_if { !enabled_status }
          end
        end

        #
        # Shell out and use AppleScript to check whether the "Alfred" login
        # item already exists.
        #
        # @return [TrueClass, FalseClass]
        #
        def enabled?
          cmd = "osascript -e 'tell application \"System Events\" to get " \
                "the name of the login item \"Alfred\"'"
          !Mixlib::ShellOut.new(cmd).run_command.stdout.empty?
        end

        #
        # (see AlfredApp#start!)
        #
        def start!
          execute 'start alfred' do
            command "open #{PATH}"
            user Etc.getlogin
            action :run
            only_if do
              cmd = 'ps -A -c -o command | grep ^Alfred$'
              Mixlib::ShellOut.new(cmd).run_command.stdout.empty?
            end
          end
        end

        #
        # Authorize the Alfred app.
        #
        # (see AlfredApp#install!)
        #
        def install!
          authorize_app!
        end

        #
        # Declare a trusted_app resource and grant Accessibility to the app.
        #
        def authorize_app!
          include_recipe 'privacy_services_manager'
          privacy_services_manager "Grant Accessibility to '#{PATH}'" do
            service 'accessibility'
            applications [PATH]
            action :add
          end
        end
      end
    end
  end
end
