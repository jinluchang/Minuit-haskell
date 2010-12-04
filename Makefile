NAME = program
HNAME = haskell
LIBS = -lm -lgsl -lgslcblas -lMinuit2 -L/usr/lib/root -L/usr/lib/root/5.18 -lCore -lCint -lRIO -lNet -lHist -lGraf -lGraf3d -lGpad -lTree -lRint -lPostscript -lMatrix -lPhysics -lz -ldl
CFLAGS = $$(root-config --cflags)
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

