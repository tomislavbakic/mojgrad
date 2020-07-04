using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class SolutionReport
    {
        public int ID { get; set; }
        public string Description { get; set; }

        public int SolutionID { get; set; }
        public virtual PostSolution PostSolution { get; set; }

        public int UserDataID { get; set; }
        public virtual UserData UserData { get; set; }
    }
}
