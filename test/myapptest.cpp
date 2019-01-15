#include "../src/myapp.h"
#include "gtest/gtest.h"

TEST(multiply, base)
{
EXPECT_EQ(1, MyApp::multiply(1,1));
EXPECT_EQ(5, MyApp::multiply(2,3));
}
