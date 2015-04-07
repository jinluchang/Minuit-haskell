name = program
cname = cprogram

hc = ghc -Wall -O2
main = Main.hs
source = *.hs

cxx = g++ -Wall -O2
cc = gcc -Wall -O2
headers = minuit-c.h
objects = minuit-c.o

clean = $(name) $(cname) *.hi *.o *_stub.*

cflags =
libs = -lm -lMinuit2 -lstdc++

all : $(name) $(cname)

run : $(name)
	./$(name)

crun : $(cname)
	./$(cname)

clean :
	rm $(clean)

$(name) : $(source) $(headers) $(objects)
	$(hc) --make -o $(name) $(main) $(objects) $(libs)

$(cname) : main.o $(objects)
	$(cxx) -o $@ main.o $(objects) $(libs)

%.o : %.cc $(headers)
	$(cxx) -c -o $@ $< $(cflags)

%.o : %.c $(headers)
	$(cc) -c -o $@ $< $(cflags)


