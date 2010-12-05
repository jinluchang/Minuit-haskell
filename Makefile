NAME = programC
HNAME = programH
LIBS = -lm -lMinuit2 -ldl -L/usr/lib/root -L/usr/lib/root/5.18
CFLAGS = -I/usr/include/root
CXX = g++ -Wall -O2
CC = gcc -Wall -O2
OBJECTS = minuit-c.o

all : $(NAME) $(HNAME)

$(HNAME) : *.hs $(OBJECTS)
	ghc -Wall -o $(HNAME) --make Main.hs $(OBJECTS) $(LIBS)

$(NAME) : main.o $(OBJECTS)
	$(CXX) -o $@ main.o $(OBJECTS) $(LIBS)

%.o : %.cc *.h
	$(CXX) -c -o $@ $< $(CFLAGS)

%.o : %.c *.h
	$(CC) -c -o $@ $< $(CFLAGS)

clean :
	rm $(NAME) $(HNAME) *.hi *.o *_stub.*

hrun : $(HNAME)
	LD_LIBRARY_PATH=/usr/lib/root/5.18 ./$(HNAME)

run : $(NAME)
	LD_LIBRARY_PATH=/usr/lib/root/5.18 ./$(NAME)

