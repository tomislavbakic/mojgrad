using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class UserPostLikes
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Lastname { get; set; }
        public string Email { get; set; }
        public int Eko { get; set; }
        public string Photo { get; set; }

        public UserPostLikes() { }
    }
}
