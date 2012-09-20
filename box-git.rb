class BoxGit  
  def help
    print "Please use 'box-git.rb box [--local] [box-type]' to initialize the Repo.\n\n" +
          "Box type can be one of the following: \n" +
          "    google   : for enabling use of Google Drive\n" +
          "    dropbox  : for enabling use of DropBox\n" +
          "    skydrive : for enabling use of Skydrive\n\n" + 
          "In case you want to use a custom path, use it like this:\n" +
          "    box-git.rb box \"C:/Users/Custom/Path\"\n" +
          "If no path is type or path is specified, the global parameter is taken.\n" +
          "Using the --local flag will allow you to set up the box for only this repo.\n\n" +
          "Use 'box-git.rb push' or 'git push --mirror box' to push to repo.\n"
          "You can use any git command using box-git.rb and it should essentially work :)\n"
  end
  
  def reset arg
    `git config --unset-all box.path`
    `git config --unset-all box.enabled`
    `git remote rm box`
  end
    
  def push args
    if box_enabled?
      system "git push --mirror box #{args}"
    else
      help
    end
  end
  
  def box args
    if self.box_enabled?
      print "Box-Git was already run and box is enabled.\n"
      print "Repo Path: #{self.box_path}\n"
      return
    end
    
    if get_base.empty?
      print "Repo was not initialized. Initializing using 'git init'."
      system "git init"
    end
    
    args = args.split
    config_scope = "--global"
    config_path = ""
    
    if args.include? "--local"
      config_scope = "--local"
      args.delete "--local"
    end
    
    if args.empty?
      if !self.box_path.empty?
        args[0] = self.box_path
      else
        help
        return
      end
    end
    
    if args.include? "dropbox"
      print "Initializing Git with Default DropBox Path.\n"
      git_box_path = "#{Dir.home}/Dropbox"
    elsif args.include? "google"
      print "Initializing Git with Default Google Drive Path.\n"
      git_box_path = "#{Dir.home}/Google Drive"
    elsif args.include? "skydrive"
      print "initializing Git with Default Skydrive Path.\n"
      git_box_path = "#{Dir.home}/Skydrive"
    else
      print "initializing Git with Custom Path.\n"
      git_box_path = args[0]
    end
    
    if !File.directory? git_box_path
      print "Unable to find directory \"#{git_box_path}\"\n\n"
      help
      return
    end
    
    config_path = git_box_path + "/repo/#{get_base}"
    
    if File.directory? config_path
      print "Directory \"#{config_path}\" already exist. Please remove it.\n"
      return
    end
    
    print "Git Repo Location: #{config_path}\n"
    
    `git config #{config_scope} --unset-all box.path`
    `git config #{config_scope} box.path \"#{git_box_path}\"`
    
    print "Setting up repo.\n"
    system "git init --bare \"#{config_path}\""
    `git config --local box.enabled true`
    
    #`git remote rm box`
    system "git remote add box \"file://#{config_path}\""
  end
  
  def method_missing name, *args
    call_git name.to_s, args[0].to_s
  end
  
  protected
  def call_git arg1, arg2 = ""
    system 'git ' + arg1 + ' ' + arg2
  end
  
  def box_enabled?
    `git config box.enabled`.strip == 'true'
  end
  
  def box_path
    `git config box.path`.strip
  end
  
  def get_base
    base = ""
    path = `git rev-parse --show-toplevel`
    path.strip!
    
    if File.directory? path
      base = File.basename path
    end
    
    return base
  end
end

git_args_array = ARGV
git_first_arg = git_args_array[0]
git_rest_args = ""

if git_args_array.count > 1
  git_args_array[0] = ""
  git_args_array.each do |arg|
    git_rest_args += arg + ' '
  end
end

git = BoxGit.new
if ARGV.count == 0
  git.help
else
  git.public_send(git_first_arg, git_rest_args)
end


