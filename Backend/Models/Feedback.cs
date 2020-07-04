using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Feedback
    {
        public int ID { get; set; }
        public string Text { get; set; }

        public int UserDataID { get; set; }
        public virtual UserData UserData { get; set; }
    }
}
