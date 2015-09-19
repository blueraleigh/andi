#!/bin/sh -f

./src/andi --help || exit 1

LENGTH=100000

for dist in 0.001 0.01 0.02 0.05 0.1 0.2 0.3
do
	for n in $(seq 10)
	do
		res=$(./test/test_fasta -l $LENGTH -d $dist |
			tee ./test/test_random.fasta |
			./src/andi -r -t 1 |
			tail -n 1 |
			awk -v dist=$dist '{print $2, dist}' |
			awk 'function abs(x){return ((x < 0.0) ? -x : x)} {print abs($1-$2) < 0.02 && abs($1-$2) < 0.02 * $2}')
		if test $res -ne 1; then
			echo "The last test computed a distance deviating more than two percent from its intended value."
			echo "See test_random.fasta for the used sequences."
			exit 1;
		fi
	done
done

rm ./test/test_random.fasta
