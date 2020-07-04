using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class OrganisationPost
    {
        public int ID { get; set; }
        public string Text { get; set; }
        public string ImagePath { get; set; }
        public DateTime Time { get; set; }

        public int OrganisationID { get; set; }
        public virtual Organisation Organisation { get; set; }
        public virtual List<OrganisationPostLike> OrganisationPostLikes { get; set; }
    }
}
