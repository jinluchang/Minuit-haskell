NAME = programC
HNAME = programH
LIBS = -lm -lMinuit2 -ldl -L/usr/lib/root -L/usr/lib/root/5.18
CFLAGS = -I/usr/include/root
CXX = g++ -Wall -O2
CC = gcc -Wall -O2
HC = ghc -Wall -O2
OBJECTS = minuit-c.o
HEADERS = minuit-c.h
HASKELLS = Main.hs Minuit.hs

all : $(NAME) $(HNAME)

hrun : $(HNAME)
	LD_LIBRARY_PATH=/usr/lib/root/5.18 ./$(HNAME)

run : $(NAME)
	LD_LIBRARY_PATH=/usr/lib/root/5.18 ./$(NAME)

clean :
	rm $(NAME) $(HNAME) *.hi *.o *_stub.*

$(HNAME) : $(HASKELLS) $(HEADERS) $(OBJECTS)
	$(HC) --make -o $(HNAME) Main.hs $(OBJECTS) $(LIBS)

$(NAME) : main.o $(OBJECTS)
	$(CXX) -o $@ main.o $(OBJECTS) $(LIBS)

%.o : %.cc $(HEADERS)
	$(CXX) -c -o $@ $< $(CFLAGS)

%.o : %.c $(HEADERS)
	$(CC) -c -o $@ $< $(CFLAGS)


