## ANTLR-4
In ubuntu apt files (at least on my machine) there are conflicting versions for antlr generator and dev library. This proved to be a major pain in the ass.
To address this problem I had to manually install correct dev library version from Debian packages website.

Here is what worked for me:
First install dependency for dev library: https://packages.debian.org/trixie/libantlr4-runtime4.9 
Then dev library: https://packages.debian.org/trixie/libantlr4-runtime-dev
Generator version (from apt): ANTLR Parser Generator  Version 4.9.2

Big thanks to @Vladislave0-0 and @aleksplast for pointing out for the problem.  