#!/bin/csh

set count=1
while ($count <= 255)
	echo "$count       IN PTR  82-201-122-$count.filmer.nl."
 	@ count++
end

