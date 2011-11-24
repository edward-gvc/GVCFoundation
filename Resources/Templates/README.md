About
-----
Some simple templates to support common patters in the GVCOpenKits.

Install
-------
From your terminal run the command

	bash templateInstall.sh

Note: Do NOT simply git clone the templates into the template folders, as Xcode will
pick up all the cruft from the .git folder.

Coding Standard
---------------
All files will be processed by Xcode. The generated source files must produce consistent,
readable, commented code. The code must have these characteristics:

- Each file must have a comment block at the top describing the file
- Each class must implement its superclass' designated initializer
- all files are assumed to be ARC
- Stub methods must be organized by their purpose, class or protocol.
-- Each group must be organized by their class hierarchy, with protocol stubs following.
-- Each group must be prefaced by a pragma mark naming the class or protocol the methods
   were implementing.
-- Clusters of methods (such as relating to KVO) should be organized along the lines
   above, with a pragma mark.
- All method implementations should contain a method call to their super implementation
  if needed.
- All method implementations should contain a commented out stub line that will signify
  where to insert their code.
