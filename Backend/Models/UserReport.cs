using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class UserReport
    {
        public int ID { get; set; }
        public string Description { get; set; }
        public int ReportedUserID { get; set; }
        public int UserDataID { get; set; }
        public virtual UserData UserData { get; set; }
    }
}
