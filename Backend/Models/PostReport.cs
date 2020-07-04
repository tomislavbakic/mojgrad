using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class PostReport
    {
        public int ID { get; set; }
        public string Description { get; set; }

        public int PostID { get; set; }
        public virtual Post Post { get; set; }

        public int UserDataID { get; set; }
        public virtual UserData UserData { get; set; }
    }
}
