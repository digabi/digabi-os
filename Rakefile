# -*- coding: utf-8 -*-
# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Tails: The Amnesic Incognito Live System
# Copyright © 2012 Tails developers <tails@boum.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'rbconfig'
require 'rubygems'
require 'vagrant'
require 'uri'

$:.unshift File.expand_path('../vagrant/lib', __FILE__)
require 'tails_build_settings'
require 'vagrant_version'

# Path to the directory which holds our Vagrantfile
VAGRANT_PATH = File.expand_path('../vagrant', __FILE__)

# Branches that are considered 'stable' (used to select SquashFS compression)
STABLE_BRANCH_NAMES = ['stable', 'testing']

# Environment variables that will be exported to the build script
EXPORTED_VARIABLES = ['http_proxy', 'MKSQUASHFS_OPTIONS', 'TAILS_RAM_BUILD', 'TAILS_CLEAN_BUILD', 'TAILS_BOOTSTRAP_CACHE']

# Let's save the http_proxy set before playing with it
EXTERNAL_HTTP_PROXY = ENV['http_proxy']

# In-VM proxy URL
INTERNEL_HTTP_PROXY = "http://#{VIRTUAL_MACHINE_HOSTNAME}:3142"

def primary_vm
  env = Vagrant::Environment.new(:cwd => VAGRANT_PATH, :ui_class => Vagrant::UI::Basic)
  if vagrant_old
    return env.primary_vm
  else
    name = env.primary_machine_name
    return env.machine(name, env.default_provider)
  end
end

def primary_vm_state
  if vagrant_old
    return primary_vm.state
  else
    return primary_vm.state.id
  end
end

def current_vm_memory
  vm = primary_vm
  uuid = vm.uuid
  info = vm.driver.execute 'showvminfo', uuid, '--machinereadable'
  $1.to_i if info =~ /^memory=(\d+)/
end

def current_vm_cpus
  vm = primary_vm
  uuid = vm.uuid
  info = vm.driver.execute 'showvminfo', uuid, '--machinereadable'
  $1.to_i if info =~ /^cpus=(\d+)/
end

def vm_running?
  primary_vm_state == :running
end

def enough_free_memory?
  return false unless RbConfig::CONFIG['host_os'] =~ /linux/i

  begin
    usable_free_mem = `free`.split[16].to_i
    usable_free_mem > VM_MEMORY_FOR_RAM_BUILDS * 1024
  rescue
    false
  end
end

def is_release?
  branch_name = `git name-rev --name-only HEAD`
  tag_name = `git describe --exact-match HEAD 2> /dev/null`
  STABLE_BRANCH_NAMES.include? branch_name.chomp or tag_name.chomp.length > 0
end

def system_cpus
  return nil unless RbConfig::CONFIG['host_os'] =~ /linux/i

  begin
    File.read('/proc/cpuinfo').scan(/^processor\s+:/).count
  rescue
    nil
  end
end

task :parse_build_options do
  options = ''

  # Default to in-memory builds if there is enough RAM available
  options += 'ram ' if enough_free_memory?

  # Use in-VM proxy unless an external proxy is set
  options += 'vmproxy ' unless EXTERNAL_HTTP_PROXY

  # Default to fast compression on development branches
  options += 'gzipcomp ' unless is_release?

  # Make sure release builds are clean
  options += 'cleanall ' if is_release?

  # Default to the number of system CPUs when we can figure it out
  cpus = system_cpus
  options += "cpus=#{cpus} " if cpus

  options += ENV['TAILS_BUILD_OPTIONS'] if ENV['TAILS_BUILD_OPTIONS']
  options.split(' ').each do |opt|
    case opt
    # Memory build settings
    when 'ram'
      unless vm_running? || enough_free_memory?
        abort "Not enough free memory to do an in-memory build. Aborting."
      end
      ENV['TAILS_RAM_BUILD'] = '1'
    when 'noram'
      ENV['TAILS_RAM_BUILD'] = nil
    # Bootstrap cache settings
    when 'cache'
      ENV['TAILS_BOOTSTRAP_CACHE'] = '1'
    when 'nocache'
      ENV['TAILS_BOOTSTRAP_CACHE'] = nil
    # HTTP proxy settings
    when 'extproxy'
      abort "No HTTP proxy set, but one is required by TAILS_BUILD_OPTIONS. Aborting." unless EXTERNAL_HTTP_PROXY
      ENV['http_proxy'] = EXTERNAL_HTTP_PROXY
    when 'vmproxy'
      ENV['http_proxy'] = INTERNEL_HTTP_PROXY
    when 'noproxy'
      ENV['http_proxy'] = nil
    # SquashFS compression settings
    when 'gzipcomp'
      ENV['MKSQUASHFS_OPTIONS'] = '-comp gzip'
    when 'defaultcomp'
      ENV['MKSQUASHFS_OPTIONS'] = nil
    # Clean-up settings
    when 'cleanall'
      ENV['TAILS_CLEAN_BUILD'] = '1'
    # Virtual CPUs settings
    when /cpus=(\d+)/
      ENV['TAILS_BUILD_CPUS'] = $1
    # Git settings
    when 'ignorechanges'
      ENV['TAILS_BUILD_IGNORE_CHANGES'] = '1'
    end
  end
end

task :ensure_clean_repository do
  unless `git status --porcelain`.empty?
    if ENV['TAILS_BUILD_IGNORE_CHANGES']
      $stderr.puts <<-END_OF_MESSAGE.gsub(/^        /, '')

        You have uncommited changes in the Git repository. They will
        be ignored for the upcoming build.

      END_OF_MESSAGE
    else
      $stderr.puts <<-END_OF_MESSAGE.gsub(/^        /, '')

        You have uncommited changes in the Git repository. Due to limitations
        of the build system, you need to commit them before building Tails.

        If you don't care about those changes and want to build Tails nonetheless,
        please add `ignorechanges` to the TAILS_BUILD_OPTIONS environment
        variable.

      END_OF_MESSAGE
      abort 'Uncommited changes. Aborting.'
    end
  end
end

task :validate_http_proxy do
  if ENV['http_proxy']
    proxy_host = URI.parse(ENV['http_proxy']).host

    if proxy_host.nil?
      ENV['http_proxy'] = nil
      $stderr.puts "Ignoring invalid HTTP proxy."
      return
    end

    if ['localhost', '[::1]'].include?(proxy_host) || proxy_host.start_with?('127.0.0.')
      abort 'Using an HTTP proxy listening on the loopback is doomed to fail. Aborting.'
    end

    $stderr.puts "Using HTTP proxy: #{ENV['http_proxy']}"
  else
    $stderr.puts "No HTTP proxy set."
  end
end

desc 'Build Tails'
task :build => ['parse_build_options', 'ensure_clean_repository', 'validate_http_proxy', 'vm:up'] do
  exported_env = EXPORTED_VARIABLES.select { |k| ENV[k] }.
                  collect { |k| "#{k}='#{ENV[k]}'" }.join(' ')
  if vagrant_old
    chan = primary_vm.channel
  else
    chan = primary_vm.communicate
  end
  status = chan.execute("#{exported_env} build-tails",
                                          :error_check => false) do |fd, data|
    (fd == :stdout ? $stdout : $stderr).write data
  end

  # Move build products to the current directory
  FileUtils.mv Dir.glob("#{VAGRANT_PATH}/tails-*"),
               File.expand_path('..', __FILE__), :force => true

  exit status
end

namespace :vm do
  desc 'Start the build virtual machine'
  task :up => ['parse_build_options', 'validate_http_proxy'] do
    case primary_vm_state
    when :not_created
      # Do not use non-existant in-VM proxy to download the basebox
      if ENV['http_proxy'] == INTERNEL_HTTP_PROXY
        ENV['http_proxy'] = nil
        restore_internal_proxy = true
      end

      $stderr.puts <<-END_OF_MESSAGE.gsub(/^      /, '')

        This is the first time that the Tails builder virtual machine is
        started. The virtual machine template is about 300 MB to download,
        so the process might take some time.

        Please remember to shut the virtual machine down once your work on
        Tails is done:

            $ rake vm:halt

      END_OF_MESSAGE
    when :poweroff
      $stderr.puts <<-END_OF_MESSAGE.gsub(/^      /, '')

        Starting Tails builder virtual machine. This might take a short while.
        Please remember to shut it down once your work on Tails is done:

            $ rake vm:halt

      END_OF_MESSAGE
    when :running
      if ENV['TAILS_RAM_BUILD'] && current_vm_memory < VM_MEMORY_FOR_RAM_BUILDS
        $stderr.puts <<-END_OF_MESSAGE.gsub(/^          /, '')

          The virtual machine is not currently set with enough memory to
          perform an in-memory build. Either remove the `ram` option from
          the TAILS_BUILD_OPTIONS environment variable, or shut the
          virtual machine down using `rake vm:halt` before trying again.

        END_OF_MESSAGE
        abort 'Not enough memory for the virtual machine to run an in-memory build. Aborting.'
      end
      if ENV['TAILS_BUILD_CPUS'] && current_vm_cpus != ENV['TAILS_BUILD_CPUS'].to_i
        $stderr.puts <<-END_OF_MESSAGE.gsub(/^          /, '')

          The virtual machine is currently running with #{current_vm_cpus}
          virtual CPU(s). In order to change that number, you need to
          stop the VM first, using `rake vm:halt`. Otherwise, please
          adjust the `cpus` options accordingly.

        END_OF_MESSAGE
        abort 'The virtual machine needs to be reloaded to change the number of CPUs. Aborting.'
      end
    end
    env = Vagrant::Environment.new(:cwd => VAGRANT_PATH, :ui_class => Vagrant::UI::Basic)
    result = env.cli('up')
    abort "'vagrant up' failed" unless result

    ENV['http_proxy'] = INTERNEL_HTTP_PROXY if restore_internal_proxy
  end

  desc 'Stop the build virtual machine'
  task :halt do
    env = Vagrant::Environment.new(:cwd => VAGRANT_PATH, :ui_class => Vagrant::UI::Basic)
    result = env.cli('halt')
    abort "'vagrant halt' failed" unless result
  end

  desc 'Re-run virtual machine setup'
  task :provision => ['parse_build_options', 'validate_http_proxy'] do
    env = Vagrant::Environment.new(:cwd => VAGRANT_PATH, :ui_class => Vagrant::UI::Basic)
    result = env.cli('provision')
    abort "'vagrant provision' failed" unless result
  end

  desc 'Destroy build virtual machine (clean up all files)'
  task :destroy do
    env = Vagrant::Environment.new(:cwd => VAGRANT_PATH, :ui_class => Vagrant::UI::Basic)
    result = env.cli('destroy', '--force')
    abort "'vagrant destroy' failed" unless result
  end
end

namespace :basebox do
  task :create_preseed_cfg => 'validate_http_proxy' do
    require 'erb'

    preseed_cfg_path = File.expand_path('../vagrant/definitions/squeeze/preseed.cfg', __FILE__)
    template = ERB.new(File.read("#{preseed_cfg_path}.erb"))
    File.open(preseed_cfg_path, 'w') do |f|
      f.write template.result
    end
  end

  desc 'Create virtual machine template (a.k.a. basebox)'
  task :create_basebox => [:create_preseed_cfg] do
    # veewee is pretty stupid regarding path handling
    Dir.chdir(VAGRANT_PATH) do
      require 'veewee'

      # Veewee assumes a separate process for each task. So we mimic that.

      env = Vagrant::Environment.new(:ui_class => Vagrant::UI::Basic)

      Process.fork do
        env.cli('basebox', 'build', 'squeeze')
      end
      Process.wait
      abort "Building the basebox failed (exit code: #{$?.exitstatus})." if $?.exitstatus != 0

      Process.fork do
        env.cli('basebox', 'validate', 'squeeze')
      end
      Process.wait
      abort "Validating the basebox failed (exit code: #{$?.exitstatus})." if $?.exitstatus != 0

      Process.fork do
        env.cli('basebox', 'export', 'squeeze')
      end
      Process.wait
      abort "Exporting the basebox failed (exit code: #{$?.exitstatus})." if $?.exitstatus != 0
    end
  end
end
