using Microsoft.AspNetCore.Mvc;

namespace SkillsRecommenderAPI.Controllers
{
    public class HelloWorldController : Controller
    {
        public IActionResult Index()
        {
            return Content("Hello, World!");
        }
    }
}
