# Encoding: UTF-8
#
# Cookbook Name:: alfred
# Library:: provider_alfred_app
#
# Copyright 2016, Brian Oldfield
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

require 'chef/provider/lwrp_base'
require_relative 'resource_alfred_app'
require_relative 'provider_alfred_app_mac_os_x'

class Chef
  class Provider
    # A Chef provider for the Alfred app.
    #
    # @author Brian Oldfield <brian@oldfield.io>
    class AlfredApp < Provider::LWRPBase
      use_inline_resources

      #
      # WhyRun is supported by this provider.
      #
      # @return [TrueClass, FalseClass]
      #
      def whyrun_supported?
        true
      end

      #
      # Install the app if it's not already.
      #
      action :install do
        install!
        new_resource.installed(true)
      end

      #
      # Enable the app to start on boot/login.
      #
      action :enable do
        enable!
        new_resource.enabled(true)
      end

      #
      # Start the app.
      #
      action :start do
        start!
        new_resource.running(true)
      end

      private

      #
      # Enable the Alfred app using whatever command is appropriate for the
      # current platform.
      #
      # @raise [NotImplementedError] if not defined for this provider.
      #
      def enable!
        raise(NotImplementedError,
              "`enable!` method not implemented for #{self.class} provider")
      end

      #
      # Start the Alfred app running using whatever command is appropriate for
      # the current platform.
      #
      # @raise [NotImplementedError] if not defined for this provider.
      #
      def start!
        raise(NotImplementedError,
              "`start!` method not implemented for #{self.class} provider")
      end

      #
      # Do the actual app installation.
      #
      # @raise [NotImplementedError] if not defined for this provider.
      #
      def install!
        raise(NotImplementedError,
              "`install!` method not implemented for #{self.class} provider")
      end
    end
  end
end
