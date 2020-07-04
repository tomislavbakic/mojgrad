using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Rank
    {
        public int ID { get; set; }
        public int MinPoints { get; set; }
        public int MaxPoints { get; set; }
        public string Name { get; set; }
        public string UrlPath { get; set; }


        //public virtual List<UserData> UserDatas { get; set; }
    }
}
