using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class CommentReport
    {
        public int ID { get; set; }
        public string Description { get; set; }
        
        public int CommentID { get; set; }
        public virtual Comment Comment { get; set; }
 
        public int UserDataID { get; set; }
        public virtual UserData UserData { get; set; }
    }
}
