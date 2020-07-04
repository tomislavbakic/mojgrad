using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class ChangePost
    {
        public int ID { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string imageURL { get; set; }
    }
}
