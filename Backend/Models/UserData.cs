using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class UserData
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Lastname { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }
        public int Eko { get; set; }
        public string Photo { get; set; }
        public int CityID { get; set; }
        public virtual City City { get; set; }

        public int RankID { get; set; }
        public virtual Rank Rank { get; set; }
        public string Gender { get; set; }
        public int Age { get; set; }



        public virtual List<PostLike> PostLikes { get; set; }
        public virtual List<PostReport> PostReports { get; set; }
        public virtual List<Post> Posts { get; set; }


        public virtual List<Comment> Comments { get; set; }
        public virtual List<CommentLike> CommentLikes { get; set; }
        public virtual List<CommentReport> CommentReports { get; set; }
        public virtual List<Feedback> Feedbacks { get; set; }
        public virtual List<BlockedUser> BlockedUsers { get; set; }
        public virtual List<UserReport> UserReports { get; set; }
    }
}
