CC=g++ -Wno-write-strings -std=c++11
mcc: mcc.y mcc.c Node.cpp mcc.h
	bison -d -t mcc.y && flex mcc.l && $(CC) -o mcc Node.cpp mcc.tab.c lex.yy.c -lfl
mcc.c: mcc.y
	
clean:
	$(RM) mcc.tab.c mcc.tab.h lex.yy.c mcc
