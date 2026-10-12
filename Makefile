AS = aarch64-linux-gnu-as
LD = aarch64-linux-gnu-ld
ASFLAGS = -g
LDFLAGS = 

TARGET = minishell
SRC = src/main.s
OBJ = src/main.o

all: $(TARGET)

$(TARGET): $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o $(TARGET)

src/main.o: $(SRC)
	$(AS) $(ASFLAGS) $(SRC) -o $(OBJ)

clean:
	rm -f src/*.o $(TARGET)

rebuild: clean all
