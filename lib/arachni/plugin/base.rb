=begin
    Copyright 2010-2012 Tasos Laskos <tasos.laskos@gmail.com>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
=end

module Arachni
module Plugin

#
# Will be extended by plugin formatters which provide plugin data formatting
# for the reports.
#
# Plugin formatters will be in turn ran by [Arachni::Report::Bas#format_plugin_results].
#
#
class Formatter

    # get the output interface
    include Arachni::UI::Output

    def initialize( plugin_data )
        @results     = plugin_data[:results]
        @description = plugin_data[:description]
    end

    def run

    end

end

#
# Arachni::Plugin::Base class
#
# An abstract class for the plugins.<br/>
# All plugins must extend this.
#
# @author: Tasos "Zapotek" Laskos
#                                      <tasos.laskos@gmail.com>
#                                      <zapotek@segfault.gr>
# @version: 0.1.1
# @abstract
#
class Base

    # get the output interface
    include Arachni::Module::Output
    include Arachni::Module::Utilities

    #
    # @param    [Arachni::Framework]    framework
    # @param    [Hash]        options    options passed to the plugin
    #
    def initialize( framework, options )
        @framework = framework
        @options   = options
    end


    #
    # OPTIONAL
    #
    def prepare( )

    end

    #
    # REQUIRED
    #
    def run( )

    end

    #
    # OPTIONAL
    #
    def clean_up( )

    end

    def wait_while_framework_running
        ::IO.select( nil, nil, nil, 1 ) while( @framework.running? )
    end

    def self.gems
        [ ]
    end

    #
    # OPTIONAL
    #
    # Only used when in Grid mode.
    #
    # Should the plug-in be distributed
    # across all instances or only run by the master
    # prior to any distributed operations?
    #
    # For example, if a plug-in dynamically modifies the framework options
    # in any way and wants these changes to be identical
    # across instances this method should return 'false'.
    #
    def self.distributable?
        false
    end

    #
    # REQUIRED IF self.distributable? RETURNS 'TRUE'
    #
    # Only used when in Grid mode.
    #
    # Merges an array of results as gathered by the plug-in when run
    # by multiple instances.
    #
    def self.merge( results )
    end

    #
    # REQUIRED
    #
    # Do not omit any of the info.
    #
    def self.info
        {
            :name           => 'Abstract plugin class',
            :description    => %q{Abstract plugin class.},
            :author         => 'Tasos "Zapotek" Laskos <tasos.laskos@gmail.com>',
            :version        => '0.1',
            :options        => [
                #                        option name       required?       description                     default
                # Arachni::OptBool.new( 'print_framework', [ false, 'Do you want to print the framework?', false ] ),
                # Arachni::OptString.new( 'my_name_is',    [ false, 'What\'s you name?', 'Tasos' ] ),
            ]
        }
    end

    def register_results( results )
        @framework.plugin_store( self, results )
    end
end

end
end