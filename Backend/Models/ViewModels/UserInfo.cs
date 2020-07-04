using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class UserInfo
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public string Lastname { get; set; }
        public string Email { get; set; }
        public int Eko { get; set; }
        public int CityID { get; set; }
        public int RankID { get; set; }
        public string CityName { get; set; }
        public string RankName { get; set; }
        public int PostsNumber { get; set; }
        public int CommentsNumber { get; set; }
        public string Photo { get; set; }
        public string RankImage { get; set; }
        public int isBlocked { get; set; }
        public int CommentReportsNumber { get; set; }
        public int PostReportsNumber { get; set; }
        public int UserReportsNumber { get; set; }
        public int AllReportsNumber { get; set; }
        public int Age { get; set; }
        public string Gender { get; set; }
        public UserInfo() { }
    }
}
