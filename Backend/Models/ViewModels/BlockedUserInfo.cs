using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class BlockedUserInfo
    {
        public int ID { get; set; }
        public int UserID { get; set; }
        public string Fullname { get; set; }
        public DateTime BlockedUntil { get; set; }
        public string Reason { get; set; }
        public string Photo { get; set; }
    }
}
