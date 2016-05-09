# Encoding: UTF-8
#
# Cookbook Name:: divvy
# Library:: provider_divvy_app_mac_os_x_app_store
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

require 'chef/provider/lwrp_base'
require_relative 'provider_divvy_app'
require_relative 'provider_divvy_app_mac_os_x'

class Chef
  class Provider
    class AlfredApp < Provider::LWRPBase
      class MacOsX < AlfredApp
        # A Chef provider for OS X App Store Alfred installs.
        #
        # @author Brian Oldfield <brian@oldfield.io>
        class AppStore < MacOsX
          private

          #
          # (see AlfredApp#install!)
          #
          def install!
            mac_app_store_app 'Alfred - Productivity Application' do
              bundle_id 'com.alfredapp.Alfred'
            end
            super
          end
        end
      end
    end
  end
end
