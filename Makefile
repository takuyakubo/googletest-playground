SRC_DIR=./src
INC_DIR=./src
TEST_DIR=./test
LIB_DIR=./lib
BIN_DIR=./bin
OBJ_DIR=./obj
GTEST_DIR=./extsrc/gtest-1.8.0/googletest

INCS += -I$(INC_DIR)

CXX=/usr/bin/clang++
CXXFLAGS = -g -Wall -Wextra

SRCS = $(SRC_DIR)/myapp.cpp
TARGET = $(LIB_DIR)/libmyapp.a
OBJS  = $(addprefix $(OBJ_DIR)/, $(notdir $(SRCS:.cpp=.o)))

default: $(TARGET)
.PHONY: default

$(TARGET): $(OBJS)
	@[ -d $(LIB_DIR) ] || mkdir -p $(LIB_DIR)
	$(AR) ruc $(TARGET) $(OBJS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@[ -d $(OBJ_DIR) ] || mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) $(INCS) -o $@ -c $<


TEST_SRCS = $(TEST_DIR)/myapptest.cpp
TEST_TARGET = $(BIN_DIR)/MyAppTest
TEST_OBJS  = $(addprefix $(OBJ_DIR)/, $(notdir $(TEST_SRCS:.cpp=.o)))
LIBS += -L$(LIB_DIR)
LIBS += -lmyapp

CPPFLAGS += -isystem $(GTEST_DIR)/include
CXXFLAGS = -g -Wall -Wextra -pthread


GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
                $(GTEST_DIR)/include/gtest/internal/*.h
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)


$(OBJ_DIR)/gtest-all.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
   	            -o $@ $(GTEST_DIR)/src/gtest-all.cc

$(OBJ_DIR)/gtest_main.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
   	            -o $@ $(GTEST_DIR)/src/gtest_main.cc

$(LIB_DIR)/gtest.a : $(OBJ_DIR)/gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

$(LIB_DIR)/gtest_main.a : $(OBJ_DIR)/gtest-all.o $(OBJ_DIR)/gtest_main.o
	$(AR) $(ARFLAGS) $@ $^

test: $(TEST_TARGET)
.PHONY: test

$(TEST_TARGET): $(TARGET) $(TEST_OBJS) $(LIB_DIR)/gtest_main.a
	@[ -d $(BIN_DIR) ] || mkdir -p $(BIN_DIR)
	$(CXX) $(LDFLAGS) -o $@ $(TEST_OBJS) \
	$(LIB_DIR)/gtest_main.a $(LIBS) -lpthread


$(OBJ_DIR)/%.o: $(TEST_DIR)/%.cpp $(GTEST_HEADERS)
	@[ -d $(OBJ_DIR) ] || mkdir -p $(OBJ_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(INCS) -o $@ -c $<

.PHONY: clean
clean:
	rm -f $(TARGET) $(TEST_TARGET) $(OBJS) $(TEST_OBJS)

.PHONY: test-exec
test-exec: $(TEST_TARGET)
	$<