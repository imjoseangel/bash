$ readonly PI=3.14
$ unset PI
-bash: unset: PI: cannot unset: readonly variable
$ cat << EOF| sudo gdb
attach $$
call unbind_variable("PI")
detach
EOF
$ echo $PI