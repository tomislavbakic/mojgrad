using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class ChangePassword
    {
        public int ID { get; set; }
        public string OldPassword { get; set; }
        public string NewPassword { get; set; }
    }
}
