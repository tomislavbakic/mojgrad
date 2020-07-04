using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class CommentReportInfo
    {
        public int ID { get; set; }
        public string Description { get; set; }
        public int CommentID { get; set; }
        public int UserDataID { get; set; }
        public string UserFullname { get; set; }
        public string CommentText { get; set; }
        public string CommentPhoto { get; set; }
        public int postID { get; set; }
        public string userPhoto { get; set; }
        public int isBlocked { get; set; }

    }
}
