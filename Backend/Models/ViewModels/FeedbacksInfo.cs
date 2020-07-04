using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models.ViewModels
{
    public class FeedbacksInfo
    {
        public int ID { get; set; }
        public string Text { get; set; }
        public int UserDataID { get; set; }
        public string FullName { get; set; }
        public string userPhoto { get; set; }
    }
}
