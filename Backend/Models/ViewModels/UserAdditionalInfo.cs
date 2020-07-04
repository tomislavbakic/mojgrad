using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class UserAdditionalInfo
    {
        public int userID { get; set; }
        public string Gender { get; set; }
        public int Age { get; set; }
        public int CityID { get; set; }
    }
}
