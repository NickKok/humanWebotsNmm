PROG1 = wavy_builder
PROG2 = slopy_builder


CXX      = g++
CXXFLAGS  = -O2 `pkg-config --cflags liboptimization-2.0` -std=gnu++0x -I../../lib/ -I/usr/include/python2.7
LDFLAGS = -L -lCppController `pkg-config --libs liboptimization-2.0` -lpython2.7

#all: $(PROG1) clean

all: $(PROG1) $(PROG2)

$(PROG1): wavy_builder.o
	$(CXX) -o $@ $^ $(LDFLAGS)

$(PROG1).o: wavy_builder.cc
	$(CXX) $< -c $(CXXFLAGS)

$(PROG2): slopy_builder.o
	$(CXX) -o $@ $^ $(LDFLAGS)

$(PROG2).o: slopy_builder.cc
	$(CXX) $< -c $(CXXFLAGS)

.PHONY: clean cleanest

clean:
	rm *.o $(PROG1) $(PROG2) *~

cleanest: clean
	rm wavy_builder slopy_builder
