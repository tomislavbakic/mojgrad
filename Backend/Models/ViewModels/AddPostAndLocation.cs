using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class AddPostAndLocation
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Time { get; set; }
        public int Active { get; set; }
        public string PostImage { get; set; }
        public int UserDataID { get; set; }

        public int CategoryID { get; set; }
        public string Address { get; set; }
        public int CityID { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
    }
}
