---
title: Short circuiting Rake in Rails
layout: post-03242013
published: true
---
## Short circuiting Rake in Rails

Running `rake` in Rails loads the entire application. This can be less than
ideal if you know that your rake task doesn't need the application. In my case,
I wanted to explore the concept of fast tests in Rails. The first step was some
exploration about just how I could
[make](http://stackoverflow.com/questions/3356742/best-way-to-load-module-class-from-lib-folder-in-rails-3)
Rails include files from, say, the `lib` folder.

Once I got that, I could develop and test all sorts of modules and classes that
weren't dependent on the Rails stack, and hence, the accompanying tests ran
really fast. Mocking and stubbing became easier, allowing myself to really do
[tell don't ask](http://pragprog.com/articles/tell-dont-ask) development, and I
could even develop my application in parallel to Rails, deferring interaction
with it until it's absolutely necessary, like Bob Martin did with the Database
in this
[talk](http://www.confreaks.com/videos/759-rubymidwest2011-keynote-architecture-the-lost-years).

If you go this route, you quickly learn that Rake takes longer to load the Rails
environment than it takes to run your tests. This is because Rails loads all of
the rake tasks for all of the libraries you've got in your Gemfile, hence, the
more libraries you have in your project, the slower rake gets.

I short circuited this by customizing the standard Rakefile:

<pre>
$ cat Rakefile
#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

def all_tasks_defined?
  Rake.application.top_level_tasks.each do |tlt|
    unless Rake::Task.task_defined? tlt
      return false
    end
  end
  true
end

Dir[File.expand_path("../lib/tasks/", __FILE__) + '/*.rake'].each do |file|
  load file
end

if all_tasks_defined?
  Rake.application.top_level_tasks.each do |tlt|
    Rake.application.invoke_task(tlt)
  end
else
  Trash::Application.load_tasks
end
</pre>

The way this Rakefile works is that if all of the tasks you're running on the
command line are tasks found in your lib/tasks folder, then it doesn't look up
anymore tasks and simple starts invoking them.

You can now write a write a custom Rake task as follows

<pre>
$ cat lib/tasks/tests.rake
require 'rake/testtask'

testtask = Rake::TestTask.new do |t|
  t.libs << "test"
  t.name = "test:libs"
  t.test_files = FileList['test/lib/*test.rb']
  t.verbose = true
end
$
</pre>

with a test helper similar to:

<pre>
$ cat test/lib/helper.rb
require 'minitest/autorun'
require 'debugger'

Dir.glob(File.expand_path('../../../lib/**/*.rb', __FILE__)).each do |file|
  require file
end
$
</pre>

and run all tests in `test/lib` without loading the Rails application. In
theory, you would then keep all of your Rails independent code in `lib/`, but
that's a matter of taste and the above code could be adapted to different
folders as well as other test suites. In terms of developing your app in
parallel to Rails, this has the added benefit of not even allowing you the
opportunity to couple your code to Rails.

Testing in Rails has long been a time consuming task for people and the tricks
associated with faster tests haven't had the time to gain major acceptance of
disapproval, so they may not be the right way forward, but this Rakefile will at
least allow you to try out all of the proposed methods.
