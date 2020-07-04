using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class CommentInfo
    {
        public int ID { get; set; }

        public string FullName { get; set; }
        public int UserDataID { get; set; }
        public string UserPhoto { get; set; }
        public string Text { get; set; }
        public int LikesNumber { get; set; }
        public int DislikesNumber { get; set; }
        public string CommentPhoto { get; set; }
        public int isLikedOrDisliked { get; set; }
        public int Awarded { get; set; }
        public int PostID { get; set; }
        public int PostActive { get; set; }
    }
}
