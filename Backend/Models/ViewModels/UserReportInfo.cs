using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class UserReportInfo
    {
        public int ID { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public int Eko { get; set; }
        public string Photo { get; set; }
        public string CityName { get; set; }
        public int ReportedUserID { get; set; }
        public string Description { get; set; }
        public string RankName { get; set; }
    }
}
