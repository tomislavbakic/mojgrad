using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class PostReportInfo
    {
        public int ID { get; set; }
        public string Description { get; set; }

        public int PostID { get; set; }
        public string PostTitle { get; set; }
        public string PostDescription { get; set; }
        public DateTime Time { get; set; }
        public string Address { get; set; }
        public string City { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }


        public int UserDataID { get; set; }
        public string UserFullname { get; set; }
    }
}
