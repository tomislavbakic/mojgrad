using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class OrganisationPostInfo
    {
        public int ID { get; set; }
        public string Text { get; set; }
        public string ImagePath { get; set; }
        public DateTime Time { get; set; }
        public int OrganisationID { get; set; }
        public string Name { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string Activity { get; set; }
        public string Location { get; set; }
        public int Verification { get; set; }
        public string OrgImagePath { get; set; }
        public int LikesNumber { get; set; }
        public int DislikesNumber { get; set; }
        public int isLikedOrDisliked { get; set; }
    }

}
