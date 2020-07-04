using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Admin
    {
        public int ID { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public int Head { get; set; }
    }
}
