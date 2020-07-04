using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class CommentLike
    {
        public int ID { get; set; }
        
        public int CommentID { get; set; }
        public virtual Comment Comment { get; set; }

        public int UserDataID { get; set; }
        public virtual UserData UserData { get; set; }
        public int LikeOrDislike { get; set; }
    }
}
