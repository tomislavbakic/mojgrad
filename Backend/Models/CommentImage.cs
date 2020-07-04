using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class CommentImage
    {
        public int ID { get; set; }
        public string ImageURL { get; set; }
        
        public int CommentID { get; set; }
        public virtual Comment Comment { get; set; }

    }
}
