using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class PostInfo
    {
        public int ID { get; set; }

        public string Title { get; set; }
        public string Description { get; set; }

        public DateTime Time { get; set; }
        public int UserID { get; set; }
        public int Active { get; set; }
        public string FullName { get; set; }    
        public string CategoryName { get; set; }
        public int CommentsNumber { get; set; }
        public int LikesNumber { get; set; }
        public string UserPhoto { get; set; }
        public string PostImage { get; set; }
        public int isLiked { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public int ReportsNumber { get; set; }
        public int isSaved { get; set; }
        public string Ago { get; set; }
    }
}
