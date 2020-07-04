using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class SavedPost
    {
        public int ID { get; set; }
        public int OrganisationID { get; set; }
        public virtual Organisation Organisation { get; set; }
        public int PostID { get; set; }
        public virtual Post Post { get; set; }
    }
}
