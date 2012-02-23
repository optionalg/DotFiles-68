require 'fileutils'
include FileUtils

RCLIST = [
  "vim", "vimrc", "zshrc", "gemrc",
  "irbrc", 'pryrc',
  "tmux.conf", "todotxt.cfg",
  "rvmrc", "ackrc", "irssi", "tmuxinator",
  "emacs", "emacs.d"
]

DIRS = %w(.oh-my-zsh)
REPOS = {
  'https://github.com/robbyrussell/oh-my-zsh.git' =>  '.oh-my-zsh',
  'git@github.com:lukaszkorecki/Private-Configs.git' => '.private'

}

class String
  def red
    colorize(self, "\e[1m\e[31m")
  end
  def green
    colorize(self, "\e[1m\e[32m")
  end
  def dark_green
    colorize(self, "\e[32m")
  end
  def yellow
    colorize(self, "\e[1m\e[33m")
  end
  def blue
    colorize(self, "\e[1m\e[34m")
  end
  def dark_blue
    colorize(self, "\e[34m")
  end
  def pur
    colorize(self, "\e[1m\e[35m")
  end
  def colorize(text, color_code)
    "#{color_code}#{text}\e[0m"
  end
end

def go_home path=''
  puts "Going home".green
  cd File.expand_path "~#{path}"
end

desc "Remove existing rc files and directories"
task :implode do
  puts "Removing .rc files and directories!"
  go_home
  begin
    rm_rf DIRS
    RCLIST.map {|i| ".#{i}"}.each{ |rc| rm rc }
  rescue
    puts "nothing to delete?".yellow
  end
  puts "finished removing".pur
end

desc "Get DotFiles and other dependencies"
task :get do
  puts "Cloning dependiencies".green
  go_home

  REPOS.each do |git_url, directory|
    puts directory.yellow
    rm_rf directory
    STDOUT << `git clone -q #{git_url} #{directory} --recursive`
  end
  puts "finished cloning".pur
end
desc "Create symlinks"
task :symlink do
  puts "Creating symlinks to rc files and such".green
  go_home
  puts ".vim".yellow
  begin
    ln_s '.DotFiles', '.vim'
  rescue
    puts "hm".red
  end
  RCLIST.map {|file| [ ".DotFiles/#{file}", ".#{file}"]}.each do |from, to|
    puts to.yellow
    begin
      rm to
    rescue =>e
      puts e.inspect.red
    end
    ln_s from, to
  end
  puts "finished symlinking".pur
end

task "Update main repo"
task :update do
  puts "Updating .DotFiles".green
  STDOUT << `git pull -q `

  Rake::Task['vim:update'].invoke

  puts "updated".pur
end

namespace :vim do
  desc "Update vim plugins"
  task :update do
    puts "Updating vim plugins".green
    go_home '/.DotFiles'
    [
      'git submodule init',
      'git submodule update',
    ].each do |cmd|
      puts cmd.green
      STDOUT << `#{cmd}`
    end

    puts "plugins updated".pur
  end

  desc "install vim plugin via pathogen (use PLUGIN)"
  task :plugin_install do
    url = ENV['PLUGIN']
    fail "no url!" if url.nil?

    name = url.split('/').last.sub('.git','')
    puts "Installing #{name} from #{url}".green
    STDOUT << `git submodule add #{url} vim/bundle/#{name}`
    STDOUT << `git submodule init`
    STDOUT << `git submodule update`
  end
end

namespace :base do
  desc "Prints out a command which installs GCC, use `rake base:gcc_command` to install it"
  task :gcc_command do
    `echo 'gcc' >> ~/.installed`
    exec "curl https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.6.pkg > GCC-10.6.pkg"
  end

  desc "Prints out a command which installs RVM, use `rake base:rvm_command` to install it"
  task :rvm_command do
    `echo 'rvm' >> ~/.installed`
    exec "bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)"
  end

  desc "Prints out a command which installs homebrew, use `rake base:brew_command` to install it"
  task :brew_command do
    `echo 'brew' >> ~/.installed`
    exec " /usr/bin/ruby -e \"$(curl -fsSL https://raw.github.com/gist/323731)\""
  end


  desc "Installs essential tools via homebrew"
  task :tools do
    [
      'ack',
      'zsh',
      'git',
      'mcabber',
      'tmux',
      'https://raw.github.com/adamv/homebrew-alt/master/duplicates/vim.rb',
    ].each do |tool|
        puts "Installing #{too}".green
        STDOUT << `brew install #{tool}`
      end
  end
end

task :setup do
  puts "SETTING UP".red
  ['implode', 'get', 'symlink', 'vim:update'].each do |task|
    Rake::Task[task].invoke
  end
  puts "="*80
  puts "Close the terminal and start a new session".green
end

