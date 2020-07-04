using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Category
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public virtual List<Post> Posts { get; set; }
    }
}
