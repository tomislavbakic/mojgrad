using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class PostSolution
    {
        public int ID { get; set; }
        public string Text { get; set; }
        public string ImagePath { get; set; }
        public int UserID { get; set; }
        // user 1, org 2
        public int UserType { get; set; }
        public int PostID { get; set; }
        public virtual Post Post { get; set; }

        public int isAwarded { get; set; }

        public virtual List<SolutionLike> SolutionLikes { get; set; }
        public virtual List<SolutionReport> SolutionReports { get; set; }
    }
}
