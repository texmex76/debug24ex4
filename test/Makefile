RAND_EXEC := rand
RAND_SRC := rand.c

all: $(RAND_EXEC)

$(RAND_EXEC): $(RAND_SRC)
	gcc -o $@ $^ -lm

clean:
	rm -rf $(RAND_EXEC)

