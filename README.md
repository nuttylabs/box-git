box-git
================================================

Simple tool to use git along with Dropbox, Skydrive or Google Drive.

With this tool you will be able to sync your repositories with any of the above free cloud spaces. Share these with your collegues. 

This is best for a small group of people working on a private project or for freelancers. It is a clever and simple alternative to the paid private git hosting offerings online. 

##How to install

Download the file

```
git clone https://github.com/nuttylabs/box-git.git
```

Currently, the script is in Ruby, but soon will be available in other formats.

##How to use

Please use `box-git.rb box [--local] [box-type]` to initialize the Repo.

Box type can be one of the following:

    google   : for enabling use of Google Drive
    dropbox  : for enabling use of DropBox
    skydrive : for enabling use of Skydrive

In case you want to use a custom path, use it like this:

    `box-git.rb box "C:/Users/Custom/Path"`

If no path is type or path is specified, the global parameter is taken.

Using the `--local` flag will allow you to set up the box for only this repo.

Use `box-git.rb push` or `git push --mirror box` to push to repo.
