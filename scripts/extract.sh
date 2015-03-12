grep 'Finished task' $1 | \
sed 's/^.*Finished \(task [0-9]*\.[0-9]*\).*in \(stage [0-9]*\.[0-9]*\).*in \([0-9]* ms\).*$/\2\t\1\t\3/g' 
