
CC = gcc
CFLAGS = -Wall -g -Isrc -Isrc/include 
SRCS = ./main.c ./src/PMPDecoder.c ./src/KCLDecoder.c ./src/PMPEncoder.c ./src/PMPUtil/PMPDumpRead.c ./src/PMPUtil/PMPWrite.c ./src/FileUtil/FileRead.c ./src/PMPUtil/PMPRead.c ./src/PMPUtil/PMPJson.c ./src/MatrixUtil/MatrixOperations.c ./src/KCLUtil/KCLCalculateTris.c ./src/KCLUtil/KCLJson.c ./src/KCLUtil/KCLRead.c ./src/KCLUtil/KCLSections.c
OBJS = $(SRCS:.c=.o)
TARGET = WiiUtils

all: $(TARGET) 

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(OBJS) $(TARGET)
