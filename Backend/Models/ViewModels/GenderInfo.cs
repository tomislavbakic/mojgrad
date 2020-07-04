using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class GenderInfo
    {
        public int NumberOfMale { get; set; }
        public int NumberOfFemale { get; set; }
        public string PercentOfMale { get; set; }
        public string PercentOfFemale { get; set; }
        public string AverageAge { get; set; }

    }
}
