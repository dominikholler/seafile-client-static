seafile-client-static
=====================

Compiled binary seafile-client for i386/x86 linux, which is more or less static linked.

Binarys are created by 
  1. chrooting by scripts/chroot.sh into the tree from natty.tar.xz
  2. installing required librarys in chrooted tree, see first comments in scripts/uild-seafile-static.sh
  3. running scripts/uild-seafile-static.sh in chrooted tree
