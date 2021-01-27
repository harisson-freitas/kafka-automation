start:
		./bin/main.sh
create:
		./bin/main.sh C 
delete: 
		./bin/main.sh D
producer:
		./bin/main.sh PT SQ 4
consumer: 
		./bin/main.sh CT
		
.PHONY:  start