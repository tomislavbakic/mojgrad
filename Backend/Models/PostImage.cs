using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class PostImage
    {
        public int ID { get; set; }
        public string ImageURL { get; set; }
       
        public int PostID { get; set; }
        public virtual Post Post { get; set; }
    }
}
