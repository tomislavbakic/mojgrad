using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Post
    {
        public int ID { get; set; }
        
        public string Title { get; set; }
        public string Description { get; set; }
        
        public DateTime Time { get; set; }
        public int Active { get; set; }
        public string PostImage { get; set; }
        public int UserDataID { get; set; }
        public virtual UserData UserData { get; set; }
        
        public int CategoryID { get; set; }
        public virtual Category Category { get; set; }
        public int LocationID { get; set; }
        public virtual Location Location { get; set; }
        public int CityID { get; set; }
        public virtual City City { get; set; }

        public virtual List<PostLike> PostLikes { get; set; }
        public virtual List<PostImage> PostImages { get; set; }
        public virtual List<PostReport> PostReports { get; set; }
        public virtual List<Comment> Comments { get; set; }
        public virtual List<PostSolution> PostSolutions { get; set; }
    }
}
