using Xunit;

namespace SkillsRecommenderAPITest
{
    public class HelloWorldTest
    {
        [Fact]
        public void Test1()
        {
            string expected = "Hello, World!";

            string actual = GetHelloWorld();

            Assert.Equal(expected, actual);
        }

        public string GetHelloWorld()
        {
            return "Hello, World!";
        }
    }
}