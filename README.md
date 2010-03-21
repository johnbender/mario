mario
=====

Mario is super small library with only two standard library dependencies to help you figure out what platform you're on. 


platform
--------
Mario's main function is providing simple methods to match your current operating system or a group of operating systems. For example if you wanted to know if your code was excuting on some version of Windows

    Mario::Platform.windows?
    
Or a Unix-like operating system

    Mario::Platform.nix?
    
If you want to be more specific you can do that too

    Mario::Platform.bsd? # or linux? or windows7? or darwin?

If for some reason you opperating system isn't represented please alert me and/or see the setup for hacking on Mario below, but in the meantime you can force which operating system you would like Mario to report

    Mario::Platform.forced = Mario::Platform::Linux

hats
----
Mario has different abilities with different hats, each hat is tied to the current operating system. To start Mario can only escape file paths properly for nix operating systems and there's still testing to be done on the windows version, but there will be more to come. To make use of Mario's version of his abilities on your platform you might do the following:

    Mario::Platform.current.shell_escape_path('C:\Some Path\With Some Spaces.filext')

Its important to note that shell_escape_path is an actual method and not what Mario would do when confronted with an oncoming koopa shell.

hacking
-------

If you want to hack on mario, and I would grateful for any patches to for all those dark little corners that need light shone on them, just do the following from your project directory after forking and cloning:

    $ bundle install
    $ bundle lock
    $ rake test
    
If all is well you're ready to roll.

license
-------

See the license file for more information.
