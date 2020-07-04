using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class UserChange
    {
        public int Id { get; set; }
        public string NewName { get; set; }
        public string NewLastname { get; set; }
        public string NewEmail { get; set; }
        public int NewAge { get; set; }
        public int NewCityID { get; set; }
    }
}
