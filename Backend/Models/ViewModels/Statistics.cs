using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class StatisticsInfo
    {
        public int NumberOfUsers { get; set; }
        public int NumberOfMobileUsers { get; set; }
        public int NumberOfOrganisations { get; set; }
        public int NumberOfPosts { get; set; }
        public string AverageGrade { get; set; }
    }
}
