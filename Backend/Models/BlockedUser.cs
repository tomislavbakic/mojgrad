using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class BlockedUser
    {
        public int ID { get; set; }
        public int UserDataID { get; set; }
        public virtual UserData UserData { get; set; }
        public DateTime BlockedUntil { get; set; }
        public string Reason { get; set; }
    }
}
