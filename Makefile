default:
	swipl -q -g main -o flp21-log -c flp21-log.pl
	#swipl -q -g main -o flp21-log -c test.pl

clean:
	rm -rf flp21-log