using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Organisation
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public string PhoneNumber { get; set; }
        public string Activity { get; set; }
        public string Location { get; set; }
        public int Verification { get; set; }
        public string ImagePath { get; set; }
    }
}

