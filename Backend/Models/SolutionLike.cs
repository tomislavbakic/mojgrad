using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class SolutionLike
    {
        public int ID { get; set; }

        public int PostSolutionID { get; set; }
        public virtual PostSolution PostSolution { get; set; }

        public int UserDataID { get; set; }
        public virtual UserData UserData { get; set; }
        public int LikeOrDislike { get; set; }
    }
}
