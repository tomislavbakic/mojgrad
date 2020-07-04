using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class CategoryInfo
    {
        public int CategoryID { get; set; }
        public string CategoryName { get; set; }
        public int NumberOfPosts { get; set; }
        public string PercentageOfAllPosts { get; set; }

    }
}
