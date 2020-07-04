using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Comment
    {
        public int ID { get; set; }
        public string Text { get; set; }

        public int PostID { get; set; }
        public virtual Post Post { get; set; }
        public int Awarded { get; set; }
        public int UserDataID { get; set; }
        public virtual UserData UserData { get; set; }
        public string CommentPhoto { get; set; }

        public virtual List<CommentImage> CommentImages { get; set; }
        public virtual List<CommentLike> CommentLikes { get; set; }
        public virtual List<CommentReport> CommentReports { get; set; }
    }
}
